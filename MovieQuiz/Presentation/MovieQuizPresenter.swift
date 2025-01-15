//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Илья Ануфриев on 13.01.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    var correctAnswers: Int = 0
    weak var view: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticServiceProtocol!
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }

    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    

    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
                 correctAnswers += 1
             }
        proceedWithAnswer(isCorrect: isCorrectAnswer)
    }
    
    private func didAnswer(isYes: Bool) {
           guard let currentQuestion = currentQuestion else {
               return
           }

           let givenAnswer = isYes
       
        didAnswer(isCorrectAnswer: givenAnswer == currentQuestion.correctAnswer)
       changeState(of: false)
           
       }

    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
     didAnswer(isYes: false)
    }
        
    func proceedToNextQuestionOrResult() {
        if self.isLastQuestion() {
            let resultMessage = makeResultsMessage()
            let text = correctAnswers == self.questionsAmount ? "Поздравляем, вы ответили на 10 из 10!\n\(resultMessage)" : "Вы ответили на \(correctAnswers) из 10. \n\(resultMessage)"
        
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
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question  = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)}
        
    }
    
    func didFailureToLoadData(with error:  Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
        
    }
    
    func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.YY HH:mm"
        let formattedDate = formater.string(from: bestGame.date)
        let bestGameText = "Количество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/10 (\(formattedDate))\nСреднаяя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return bestGameText
        
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResult()
        }
    }
}

