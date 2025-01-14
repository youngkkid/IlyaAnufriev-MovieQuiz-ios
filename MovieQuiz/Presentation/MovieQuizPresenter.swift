//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 13.01.2025.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

    
    func yesButtonClicked() {
        
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        
        viewController?.showAnswersResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = false
        
        viewController?.showAnswersResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
