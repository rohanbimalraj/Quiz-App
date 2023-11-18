//
//  Quiz.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import Foundation

struct Quiz: Codable {

    let questions: [Question]
    
    struct Question: Codable {
        let question: String
        let correctAnswer: String
        let incorrectAnswers: [String]
        var choices: [String] {
            var temp: [String] = []
            temp.append(contentsOf: incorrectAnswers)
            temp.append(correctAnswer)
            return temp.shuffled()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case questions = "results"
    }
}
