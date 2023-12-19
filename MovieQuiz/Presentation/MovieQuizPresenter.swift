//
//  MovieQuizPresenter.swift
//  MovieQuiz
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
        let viewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return viewModel
    }
    
    func yesButtonClicked() {
//        noButton.isEnabled = false
//        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == true {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }
    
    func noButtonClicked() {
//        noButton.isEnabled = false
//        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        if currentQuestion.correctAnswer == false {
            viewController?.showAnswerResult(isCorrect: true)
        } else {
            viewController?.showAnswerResult(isCorrect: false)
        }
    }
    
    
}
