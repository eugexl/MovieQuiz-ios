//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 10.07.2023.
//

import Foundation

/// Структура вопроса
/// - Parameters:
///     - image: Данные изображения
///     - text: Текст вопроса
///     - correctAnswer: Верный Ответ на вопрос
struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
}

