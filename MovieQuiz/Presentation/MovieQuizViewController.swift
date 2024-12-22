import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    private var alertPresentor: ResultAlertPresentor?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var statisticService: StatisticServiceProtocol!
    
    
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question:model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswersResult(isCorrect: Bool){
        if isCorrect {correctAnswers += 1}
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 20
        changeState(of: false)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0) {[weak self] in
            guard let self = self else {return}
            self.showNextQuestionOrResult()
        }
    }
    
    private func showNextQuestionOrResult () {
        if currentQuestionIndex == questionsAmount - 1{ let text = "Ваш результат: \(correctAnswers)/10"
            let bestGame = statisticService.bestGame
            let formater = DateFormatter()
            formater.dateFormat = "dd.MM.YY hh:mm"
            let formattedDate = formater.string(from: bestGame.date)
            let bestGameText = "Количество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/10 (\(formattedDate))\nСреднаяя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: "\(text)\n\(bestGameText)", buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            resetBorder()
            changeState(of: true)
        } else {currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            resetBorder()
            changeState(of: true)
        }
    }
    
    
    private func show(quiz result: QuizResultsViewModel){
        let alert = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {[weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresentor?.showAlert(result: alert)
    }
    
    
    private func resetBorder() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    private func changeState(of button: Bool) {
        yesButton.isEnabled = button
        noButton.isEnabled = button
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBorder()
        alertPresentor = ResultAlertPresentor(viewController: self)
        statisticService = StatisticServiceImplementation()
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async{ [weak self] in
            self?.show(quiz: viewModel)
        }
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = true
        
        showAnswersResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        
        showAnswersResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
