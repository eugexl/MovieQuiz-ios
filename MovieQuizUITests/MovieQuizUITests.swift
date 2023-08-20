//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Eugene Dmitrichenko on 06.08.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        app = XCUIApplication()

        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()

        app.terminate()
        app = nil

    }
    
    func testYesButton(){
        sleep(3)
        
        // Getting first image png-representation
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        
        // Getting second image png-representation
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }

    func testNoButton() {
        sleep(3)
        
        app.buttons["No"].tap()
        
        sleep(3)
        
        let questionIndex = app.staticTexts["QuestionIndex"]
        
        XCTAssertEqual(questionIndex.label, "2/10")
    }
    
    func testAlertPopsUp() throws {
        
        // UI tests must launch the application that they test.

        sleep(2)

        let button = app.buttons["Да"]

        let ifAlertExists = app.alerts.firstMatch.exists

        print("IfAlert")
        print(ifAlertExists)

        for _ in 0...9 {

            button.tap()
            sleep(3)
        }

        let alert = app.alerts.firstMatch

        XCTAssertTrue(alert.exists)
        
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")

        sleep(4)
    }
    
    func testNextQuiz() {
        sleep(2)
        
        let button = app.buttons["Да"]
        
        for _ in 0...9 {
            
            button.tap()
            sleep(3)
        }
        
        let alert = app.alerts.firstMatch
        
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let questionIndex = app.staticTexts["QuestionIndex"]
        
        XCTAssertTrue(questionIndex.label == "1/10")
        
        XCTAssertFalse(alert.exists)
        
    }
}
