//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 25.07.2023.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - Network Client
/// Структура выполняющая сетевые операции для приложения
struct NetworkClient: NetworkRouting {
    
    /// IMDB API KEY
    enum imdbAPIKey: String {
        case myImdbApiKey = "k_4w3gz813"
        case ypImdbApiKey = "k_zcuw1ytf"
        case testImdbApiKey = "k_12345678"
    }
    
    /// Возможные ошибки сетевого уровня
    enum NetworkError: Error, LocalizedError{
        case codeError
        case wrongData
        case noData
        
        var errorDescription: String? {
            switch self {
            case .codeError:
                return NSLocalizedString("Не получилось декодировать данные", comment: "Проблема с кодированием")
            case .wrongData:
                return NSLocalizedString("Сервер вернул некорректные данные", comment: "Неверные данные")
            case .noData:
                return NSLocalizedString("Сервер не предоставил даннных", comment: "Нет данных")
            }
        }
    }
    
    /// Запрашиваем данные с сервера
    func fetch (url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        // Подготавливаем HTTPS-запрос
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // В случае возникновении ошибки возвращаем её замыканию
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем успешность HTTPS-запроса
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Проверяем, пришли ли данные с сервера
            guard let data = data else {
                handler(.failure(NetworkError.wrongData))
                return
            }
            
            handler(.success(data))
        }
        
        // Выполняем HTTPS-запрос
        task.resume()
    }
}


//MARK: - Stub Network Client

struct StubNetworkClient: NetworkRouting {
    
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponse))
        }
    }
    
    private var expectedResponse: Data {
        """
        {
        "errorMessage" : "",
           "items" : [
              {
                 "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                 "fullTitle" : "Prey (2022)",
                 "id" : "tt11866324",
                 "imDbRating" : "7.2",
                 "imDbRatingCount" : "93332",
                 "image" : "https://m.media-amazon.com/images/M/MV5BMDBlMDYxMDktOTUxMS00MjcxLWE2YjQtNjNhMjNmN2Y3ZDA1XkEyXkFqcGdeQXVyMTM1MTE1NDMx._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "1",
                 "rankUpDown" : "+23",
                 "title" : "Prey",
                 "year" : "2022"
              },
              {
                 "crew" : "Anthony Russo (dir.), Ryan Gosling, Chris Evans",
                 "fullTitle" : "The Gray Man (2022)",
                 "id" : "tt1649418",
                 "imDbRating" : "6.5",
                 "imDbRatingCount" : "132890",
                 "image" : "https://m.media-amazon.com/images/M/MV5BOWY4MmFiY2QtMzE1YS00NTg1LWIwOTQtYTI4ZGUzNWIxNTVmXkEyXkFqcGdeQXVyODk4OTc3MTY@._V1_Ratio0.6716_AL_.jpg",
                 "rank" : "2",
                 "rankUpDown" : "-1",
                 "title" : "The Gray Man",
                 "year" : "2022"
              }
            ]
        }
       """.data(using: .utf8) ?? Data()
    }
}
