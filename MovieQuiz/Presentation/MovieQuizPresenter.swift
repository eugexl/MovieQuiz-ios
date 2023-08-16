//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 16.08.2023.
//

import UIKit

final class MovieQuizPresenter {
    
    /// Количество вопросов в игре
    let questionsAmount: Int = 10
    /// Индекс текущего вопроса
    var currentQuestionIndex: Int = 0
    
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    /// Подготовка вопроса к визуализации
    /// - Parameters:
    ///     - question: QuizQuestion-структура
    /// - Returns: Возвращает структуру "QuizStepViewModel" для отображения вопроса в представлении
    func convert(question: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
}
