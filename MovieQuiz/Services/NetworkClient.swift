//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 25.07.2023.
//

import Foundation

struct NetworkClient {
    
    /// IMDB API KEY
    enum imdbAPIKey: String {
        case ypImdbApiKey = "k_zcuw1ytf"    // YP IMDB API KEY
        case myImdbApiKey = "k_4w3gz813"    // MY IMDB API KEY
    }
    
    /// Возможные ошибки сетевого уровня
    private enum NetworkError: Error{
        case codeError
        case wrongData
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
