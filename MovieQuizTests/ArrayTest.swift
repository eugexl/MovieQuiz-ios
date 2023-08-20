//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Eugene Dmitrichenko on 20.08.2023.
//

import XCTest
@testable import MovieQuiz

final class ArrayTest: XCTestCase {
    
    func testGetValueInRange() throws {
        print("Get value in range test")
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 2]
        
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        print("Get value out of range test")
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array[safe: 20]
        
        // Then
        XCTAssertNil(value)
    }
    
}
