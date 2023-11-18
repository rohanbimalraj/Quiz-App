//
//  QuestionCollectionViewCell.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 13/11/23.
//

import UIKit

class QuestionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var optionOneLabel: UILabel!
    @IBOutlet weak var optionTwoLabel: UILabel!
    @IBOutlet weak var optionThreeLabel: UILabel!
    @IBOutlet weak var optionFourLabel: UILabel!
    
    @IBOutlet weak var optionOneView: UIView!
    @IBOutlet weak var optionTwoView: UIView!
    @IBOutlet weak var optionThreeView: UIView!
    @IBOutlet weak var optionFourView: UIView!
    
    var optionHandler: ((String) -> Bool)? //Send answer back to view controller
    private var choices: [String] = []
    override func prepareForReuse() {
        super.prepareForReuse()
        
        optionOneView.gestureRecognizers?.removeAll()
        optionTwoView.gestureRecognizers?.removeAll()
        optionThreeView.gestureRecognizers?.removeAll()
        optionFourView.gestureRecognizers?.removeAll()
        
        optionOneView.backgroundColor = UIColor(appColor: .wattle)
        optionTwoView.backgroundColor = UIColor(appColor: .wattle)
        optionThreeView.backgroundColor = UIColor(appColor: .wattle)
        optionFourView.backgroundColor = UIColor(appColor: .wattle)
        
        choices = []
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.setRadiusAndShadow()
    
    }
    
    func setQuestion(_ question: Quiz.Question) {
        setTapGestures()
        
        //MARK: To convert html codes to utf8
        questionLabel.text = String(htmlEncodedString: question.question)
        choices = question.choices
        optionOneLabel.text = String(htmlEncodedString: choices[0])
        optionTwoLabel.text = String(htmlEncodedString: choices[1])
        optionThreeLabel.text = String(htmlEncodedString: choices[2])
        optionFourLabel.text = String(htmlEncodedString: choices[3])
        
        //MARK: Set accessibility labels
        questionLabel.isAccessibilityElement = true
        questionLabel.accessibilityLabel = "Question: " + (String(htmlEncodedString: question.question) ?? "")
        
        optionOneView.isAccessibilityElement = true
        optionOneView.accessibilityValue = nil
        optionOneView.accessibilityTraits = .button
        optionOneView.accessibilityLabel = "Option one: " + (String(htmlEncodedString: choices[0]) ?? "")
        
        optionTwoView.isAccessibilityElement = true
        optionTwoView.accessibilityValue = nil
        optionTwoView.accessibilityTraits = .button
        optionTwoView.accessibilityLabel = "Option two: " + (String(htmlEncodedString: choices[1]) ?? "")
        
        optionThreeView.isAccessibilityElement = true
        optionThreeView.accessibilityValue = nil
        optionThreeView.accessibilityTraits = .button
        optionThreeView.accessibilityLabel = "Option three: " + (String(htmlEncodedString: choices[2]) ?? "")
        
        optionFourView.isAccessibilityElement = true
        optionFourView.accessibilityValue = nil
        optionFourView.accessibilityTraits = .button
        optionFourView.accessibilityLabel = "Option four: " + (String(htmlEncodedString: choices[3]) ?? "")
    }
    
    private func setTapGestures() {
        
        let optionOneTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        optionOneTap.name = "1"
        optionOneView.addGestureRecognizer(optionOneTap)
        
        let optionTwoTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        optionTwoTap.name = "2"
        optionTwoView.addGestureRecognizer(optionTwoTap)
        
        let optionThreeTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        optionThreeTap.name = "3"
        optionThreeView.addGestureRecognizer(optionThreeTap)
        
        let optionFourTap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        optionFourTap.name = "4"
        optionFourView.addGestureRecognizer(optionFourTap)
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        
        switch gesture.name {
        case "1":
            let isCorrect = optionHandler?(choices[0]) ?? false
            optionOneView.accessibilityLabel = nil
            optionTwoView.isAccessibilityElement = false
            optionThreeView.isAccessibilityElement = false
            optionFourView.isAccessibilityElement = false
            optionOneView.accessibilityValue = isCorrect ? "Correct" : "Wrong"
            optionOneView.backgroundColor = isCorrect ? .systemGreen : .systemRed
            
        case "2":
            let isCorrect = optionHandler?(choices[1]) ?? false
            optionTwoView.accessibilityLabel = nil
            optionThreeView.isAccessibilityElement = false
            optionFourView.isAccessibilityElement = false
            optionTwoView.accessibilityValue = isCorrect ? "Correct" : "Wrong"
            optionTwoView.backgroundColor = isCorrect ? .systemGreen : .systemRed
            
        case "3":
            let isCorrect = optionHandler?(choices[2]) ?? false
            optionThreeView.accessibilityLabel = nil
            optionFourView.isAccessibilityElement = false
            optionThreeView.accessibilityValue = isCorrect ? "Correct" : "Wrong"
            optionThreeView.backgroundColor = isCorrect ? .systemGreen : .systemRed
            
        case "4":
            let isCorrect = optionHandler?(choices[3]) ?? false
            optionFourView.accessibilityLabel = nil
            optionFourView.accessibilityValue = isCorrect ? "Correct" : "Wrong"
            optionFourView.backgroundColor = isCorrect ? .systemGreen : .systemRed
            
        default:
            break
        }
    }
}
