//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 13.01.2025.
//

import UIKit

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    var questionFactory: QuestionFactoryProtocol?
    var correctAnswers: Int = 0
    weak var view: MovieQuizProtocol?
    
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
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = isYes
        
        viewController?.showAnswersResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
     didAnswer(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return }
        
        currentQuestion = question
        let viewModel = self.convert(model: question)
        
        DispatchQueue.main.async{ [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        
    }
    
    func showNextQuestionOrResult() {
        if self.isLastQuestion() {
            let text = "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
        
            let viewModel = QuizResultsViewModel (title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
            resetBorder()
            changeState(of: true)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            resetBorder()
            changeState(of: true)
        }
    }
    
    func resetBorder() {
        view?.resetBorder()
    }
    
    func changeState(of button: Bool) {
        view?.changeState(of: button)
    }
    
}
