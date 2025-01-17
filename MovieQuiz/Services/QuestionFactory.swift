//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 09.07.2023.
//

import Foundation

// MARK: - Фабрика вопросов

final class QuestionFactory: QuestionFactoryProtocol {
    
    /// Делегат - получатель Квиз-вопросов
    weak var delegate: QuestionFactoryDelegate?
    
    /// Массив данных о фильмах
    private var movies: [MostPopularMovie] = []
    
    /// Инициализация фабрики вопросов с иньекцией делегата
    init(delegate: QuestionFactoryDelegate){
        self.delegate = delegate
        
        loadData()
    }
    
    /// Метод возвращающий опциональную модель вопроса - QuizQuestion
    func requestNextQuestion(){
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            do {
                
                // Пытаемся получить изображение из сети по ссылке
                imageData = try Data(contentsOf: movie.resizedImageURL)
                
            } catch {
                
               // В случае неудачи пробуем задать вопрос с картинкой по другому фильму
                print("Failed to load image data")
                DispatchQueue.main.async {
                    let alertModel = AlertModel(title: "Ошибка", message: "Не удалось загрузить изображение", buttonText: "Повторить") { _ in
                        
                        self.requestNextQuestion()
                    }
                    self.delegate?.alertPresenter?.alert(with: alertModel)
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
           
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    /// Loading movies data from server
    func loadData(){
        
        let moviesLoader = MoviesLoader()
        
        // Запускаем Activity indicator
        delegate?.showLoadingIndicator(is: true)
        
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let moviesHeap):
                    self.movies = moviesHeap.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}

// MARK: - QuestionFactoryProtocol

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
}

// MARK: - QuestionFactoryDelegate

protocol QuestionFactoryDelegate: AnyObject {
    var alertPresenter: AlertPresenterProtocol? { get }
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func showLoadingIndicator(is: Bool)
}
