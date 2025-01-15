import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizProtocol,QuestionFactoryDelegate {
    // MARK: - Lifecycle
    private var alertPresenter: ResultAlertPresenter?
    
    private var correctAnswers = 0

    
     private var questionFactory: QuestionFactoryProtocol?
    
    
    private var statisticService: StatisticServiceProtocol!
    
    private let presenter = MovieQuizPresenter()
    
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
     func showAnswersResult(isCorrect: Bool){
        if isCorrect {correctAnswers += 1}
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor =  isCorrect ? UIColor.ypGreenIOS.cgColor : UIColor.ypRedIOS.cgColor
        imageView.layer.cornerRadius = 20
        changeState(of: false)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.0) {[weak self] in
            guard let self = self else {return}
            self.presenter.correctAnswers = self.correctAnswers
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResult() 
        }
    }
    
     func showNextQuestionOrResult () {
       if  presenter.isLastQuestion() { let text = "Ваш результат: \(presenter.questionsAmount)/10"
            let bestGame = statisticService.bestGame
            let formater = DateFormatter()
            formater.dateFormat = "dd.MM.YY HH:mm"
            let formattedDate = formater.string(from: bestGame.date)
            let bestGameText = "Количество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/10 (\(formattedDate))\nСреднаяя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let viewModel = QuizResultsViewModel(title: "Этот раунд окончен!", text: "\(text)\n\(bestGameText)", buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
        } else { presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    
     func show(quiz result: QuizResultsViewModel){
        let alert = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {[weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        })
        alertPresenter?.showAlert(result: alert)
    }
    
    
     func resetBorder() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
     func changeState(of button: Bool) {
        yesButton.isEnabled = button
        noButton.isEnabled = button
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать ещё раз") {[weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(result: model)
        
    }
    
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
        
    }
    
    func didFailureToLoadData(with error:  Error) {
        showNetworkError(message: error.localizedDescription)
        print("error")
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetBorder()
        alertPresenter = ResultAlertPresenter(viewController: self)
        let factory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory = factory
        statisticService = StatisticService()
        questionFactory?.loadData()
        showLoadingIndicator()
        presenter.questionFactory = questionFactory
        presenter.viewController = self
        presenter.view = self
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {        presenter.yesButtonClicked()
    }
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
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
