//
//  ScoreAlertViewController.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 14/11/23.
//

import UIKit

class ScoreAlertViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    
    var score: Int!
    var okButtonClicked: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.setRadiusAndShadow() 
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoreLabel.text = String(score)
        UIView.animate(withDuration: 0.4, delay: 0.3) {
            self.view.transform = .identity
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        okButtonClicked?()
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.4) {
            self.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
        }completion: { _ in
            self.dismiss(animated: true)
        }
    }
}

#Preview("ScoreAlertViewController") {
    let vc: ScoreAlertViewController = UIStoryboard.main.instantiate()
    vc.score = 10
    return vc
}
