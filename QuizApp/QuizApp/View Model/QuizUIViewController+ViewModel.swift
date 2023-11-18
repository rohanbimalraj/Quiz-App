//
//  QuizUIViewController+ViewModel.swift
//  QuizApp
//
//  Created by Rohan Bimal Raj on 12/11/23.
//

import UIKit

protocol QuizViewModelDelegate: AnyObject {
    func didFetchQuizQuestions()
    func failedToFetchQuestions(with error: Error)
    func didUpdateScore(current score: Int)
    func quizDidFinish()
}

extension QuizViewController {
    
    @MainActor
    class ViewModel {
        
        private var loadingTask: Task<Void, Never>?
        weak var delegate: QuizViewModelDelegate?
        private(set) var questions: [Quiz.Question] = []
        private(set) var currentQuestionIndex: Int = 0
        private(set) var currentScore: Int = 0
        
        deinit {
            loadingTask?.cancel()
        }
        
        func fetchQuizQuestions() {
            loadingTask = Task{
                
                let result = await NetworkManager.shared.getData()
                switch result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let quiz = try? decoder.decode(Quiz.self, from: data) else {
                        delegate?.failedToFetchQuestions(with: AppErrors.failedToDecode)
                        return
                    }
                    self.questions = quiz.questions
                    print("Questions:", self.questions)
                    delegate?.didFetchQuizQuestions()
                case .failure(let error):
                    delegate?.failedToFetchQuestions(with: error)
                }
            }
        }
        
        func validateAnswer(answer: String) -> Bool {
            let isCorrect = questions[currentQuestionIndex].correctAnswer == answer
            if isCorrect {
                currentScore += 1
            }
            delegate?.didUpdateScore(current: currentScore)
            return isCorrect
        }
        
        func incrementQuestionIndex() {
            guard (self.currentQuestionIndex + 1) < 10 else { 
                delegate?.quizDidFinish()
                return
            }
            self.currentQuestionIndex += 1
        }
    }
}
