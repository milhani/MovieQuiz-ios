import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var questionTitleLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var yesButton: UIButton!

    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    private lazy var statisticService: StatisticService = StatisticServiceImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            presenter.yesButtonClicked()
        }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            presenter.noButtonClicked()
        }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderWidth = 0
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
        presenter.showNextQuestionOrResults()
//        if presenter.isLastQuestion() {
//            let text = "Вы ответили на \(presenter.correctAnswers) из 10, попробуйте еще раз!"
//
//            let viewModel = QuizResultsViewModel(
//                title: "Этот раунд окончен!",
//                text: text,
//                buttonText: "Сыграть ещё раз")
//            show(quiz: viewModel)
//        } else {
//            //currentQuestionIndex += 1
//            questionFactory?.requestNextQuestion()
//        }
    }
    
    func show(quiz result: QuizResultsViewModel) {
        statisticService.store(correct: presenter.correctAnswers, total: presenter.questionsAmount)
        
        let alertModel = AlertModel(
            title: result.title,
            message: """
                    Ваш результат: \(presenter.correctAnswers)/\(presenter.questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                    Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                    """,
            buttonText: result.buttonText,
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.resetQuestionIndex()
                self.presenter.restartGame()
            })
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.presenter.resetQuestionIndex()
                self.presenter.restartGame()
            })
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func setupViews() {
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
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
