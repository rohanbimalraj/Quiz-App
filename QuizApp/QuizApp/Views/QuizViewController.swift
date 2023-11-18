//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//
import Lottie
import UIKit

class QuizViewController: UIViewController {

    
    @IBOutlet weak var questionCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var quitButton: UIButton!
    
    private var isQuizCompleted = false
    private let vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        configureAccessibility()
    }
    
    private func initialSetUp() {
        
        //MARK: Initial view setup
        quitButton.setRadiusAndShadow()
        questionCollectionView.isHidden = true
        scoreLabel.isHidden = true
        questionNumberLabel.isHidden = true
        quitButton.isHidden = true
        
        //MARK: Set view model delegate and get questions
        vm.delegate = self
        vm.fetchQuizQuestions()
        
        //MARK: Set up and start Lottie loader
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        startLoader()
        
        //MARK: Set collection view delegate and data source
        questionCollectionView.register(UINib(nibName: "QuestionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuestionCollectionViewCell")
        questionCollectionView.delegate = self
        questionCollectionView.dataSource = self
        
    }
    
    private func configureAccessibility() {
        questionCollectionView.isAccessibilityElement = false
        quitButton.accessibilityHint = "Press the button to exit the quiz"
        questionNumberLabel.accessibilityHint = "Indicates current question you are on"
    }
    
    private func startLoader() {
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve) {
            self.animationView.isHidden = false
        }completion: { _ in
            self.animationView.play()
        }
    }
    
    private func stopLoader(showUI : Bool) {
        
        UIView.transition(with: self.view, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.animationView.isHidden = true
        }) { _ in
            showUI ? self.showUI() : ()
            self.animationView.stop()
        }
    }
    
    private func showUI() {
        UIView.transition(with: self.view, duration: 0.5, options: .transitionCrossDissolve) {
            self.questionCollectionView.isHidden = false
            self.scoreLabel.isHidden = false
            self.questionNumberLabel.isHidden = false
            self.quitButton.isHidden = false
        }
    }
    
    private func changeAccessibilityFocus() {
        guard (isQuizCompleted == false) else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { //A Delay of 2 sec is given so that cells come into view after reload and scrollTo
            let cell = self.questionCollectionView.cellForItem(at: IndexPath(item: self.vm.currentQuestionIndex, section: 0))
            self.view.accessibilityElements = [self.quitButton, self.scoreLabel, cell, self.questionNumberLabel] as? [Any]// Accessibilty elements are updated in order for voice over to read only visible cell of collection view. In default behaviour all the cells are read which is not desireable.
            UIAccessibility.post(notification: .screenChanged, argument: cell)
        }
    }
    
    @IBAction func quitButtonAction(_ sender: UIButton) {
        let alertVC = UIAlertController(title: "Are you sure you want to quit?", message: "All your progress will be loast", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "No", style: .default))
        self.present(alertVC, animated: true)
    }
    
}

extension QuizViewController: QuizViewModelDelegate {
    
    func quizDidFinish() {
        isQuizCompleted = true
        let alertVc: ScoreAlertViewController = UIStoryboard.main.instantiate()
        alertVc.modalPresentationStyle = .overCurrentContext
        alertVc.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)// For scale effect
        alertVc.score = vm.currentScore
        alertVc.okButtonClicked = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (UIAccessibility.isVoiceOverRunning ? 1.0 : 0.0)) { //Delay presenting alert till voice over completes
            UIAccessibility.post(notification: .screenChanged, argument: alertVc)
            self.present(alertVc, animated: true)
        }
    }
    
    func didUpdateScore(current score: Int) {
        self.scoreLabel.text = "SCORE: \(score)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //A delay is added to show user whether their selected choice is correct or not before going to next question
            self.vm.incrementQuestionIndex()
            self.questionCollectionView.scrollToItem(at: IndexPath(item: self.vm.currentQuestionIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.changeAccessibilityFocus()
            self.questionNumberLabel.text = "\(self.vm.currentQuestionIndex + 1) Of 10"
        }
    }
    
    func didFetchQuizQuestions() {
        stopLoader(showUI: true)
        questionCollectionView.reloadData()
        changeAccessibilityFocus()
    }
    
    func failedToFetchQuestions(with error: Error) {
        stopLoader(showUI: false)
        let alertVC = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alertVC.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.startLoader()
            self.vm.fetchQuizQuestions()
        }))
        
        self.present(alertVC, animated: true)
    }
}

extension QuizViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionViewCell", for: indexPath) as? QuestionCollectionViewCell {
            cell.setQuestion(vm.questions[indexPath.row])
            cell.optionHandler = { [weak self] (answer) -> Bool in
                return self?.vm.validateAnswer(answer: answer) ?? false
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: questionCollectionView.bounds.width, height: questionCollectionView.bounds.height)
    }
}
