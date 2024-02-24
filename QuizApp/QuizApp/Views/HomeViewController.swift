//
//  HomeViewController.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var welcomeToLabel: UILabel!
    
    @IBOutlet weak var bannerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var startViewCenterConstraint: NSLayoutConstraint!
    
    var shape: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        configureAccessiblity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.bannerTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
            self.startViewCenterConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shape?.removeFromSuperlayer()
        drawBanner()
    }
    
    private func drawBanner() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(appColor: .atoll)?.cgColor
        let bannerWidth = bannerView.bounds.width
        let bannerHeight = bannerView.bounds.height
        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)
        bezierPath.addLine(to: CGPoint(x: bannerWidth, y: 0))
        bezierPath.addLine(to: CGPoint(x: bannerWidth, y: bannerHeight * 0.8))
        bezierPath.addCurve(to: CGPoint(x: 0, y: bannerHeight * 0.8), controlPoint1: CGPoint(x: bannerWidth, y: bannerHeight + 20), controlPoint2: CGPoint(x: 0, y: bannerHeight + 20))
        bezierPath.addLine(to: .zero)
        bezierPath.close()
        shapeLayer.path = bezierPath.cgPath
        self.bannerView.layer.insertSublayer(shapeLayer, at: 0)
        self.shape = shapeLayer
        self.bannerView.layer.shadowPath = bezierPath.cgPath
        shape?.shadowColor = UIColor.darkGray.cgColor
        shape?.shadowOpacity = 0.8
        shape?.shadowOffset = CGSize(width: 0, height: 5)
        shape?.shadowRadius = 8
        
    }
    
    private func initialSetUp() {
        
        //MARK: Hide nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //MARK: Set attributed text for welcome label
        let welcomeText = NSMutableAttributedString(string: "Welcome to", attributes: [.font: UIFont(name: "SnellRoundhand-Black", size: 55) as Any])
        welcomeText.append(NSMutableAttributedString(string: "\nQUIZ APP", attributes: [.font: UIFont(name: "Montserrat-Black", size: 55) as Any]))
        welcomeToLabel.attributedText = welcomeText
        
        //MARK: Hide welcome label and start button initially
        bannerTopConstraint.constant = -bannerView.bounds.height
        startViewCenterConstraint.constant = -bannerView.bounds.width
        
        //MARK: Add drop shadow to start button
        startView.setRadiusAndShadow(radius: 35)
        
        //MARK: Add tap gesture to startView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        startView.addGestureRecognizer(tapGesture)
    }
    
    private func configureAccessiblity() {
        welcomeToLabel.accessibilityTraits = .header
        startView.accessibilityTraits = .button
        startView.accessibilityLabel = "Start"
        startView.accessibilityHint = "Press to start the quiz"
    }
    
    @objc func didTap() {
        let quizVc: QuizViewController = UIStoryboard.main.instantiate()
        self.navigationController?.pushViewController(quizVc, animated: true)
    }
}
#Preview("HomeViewController") {
    let vc: HomeViewController =  UIStoryboard.main.instantiate()
    return vc
}
