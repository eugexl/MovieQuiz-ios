//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Eugene Dmitrichenko on 06.08.2023.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTest: XCTestCase {
    func testSuccessLoading() throws {
        
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
                
            case .success(let movies):
                // Testing movies dictionary ...
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
                
            case .failure(_):
                XCTFail("Unexpected failure")   // Test failed
            }
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        
        // Given
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
       
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
                
            case .success(_):
                XCTFail("Unexpected failure")
                
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
