//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Eugene Dmitrichenko on 25.07.2023.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

///
struct MoviesLoader: MoviesLoaderProtocol {
    
    private let networkClient = NetworkClient()
   
    /// Формируем URL HTTPS-запроса
    private var mostPopularMoviesURL: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/\(NetworkClient.imdbAPIKey.ypImdbApiKey.rawValue)") else {
            preconditionFailure("Unable to construct mostPopularMoviesURL")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesURL) { result in
            switch result {
                
            case .success(let data):
                do {
                    let moviesHeap = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(moviesHeap))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
                print(error)
            }
        }
    }
}

