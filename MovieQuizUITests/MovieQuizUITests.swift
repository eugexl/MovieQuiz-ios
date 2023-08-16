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
     
        app = XCUIApplication()
        
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        app.terminate()
        
    }
     
    func testExample() throws {
        // UI tests must launch the application that they test.
        
        sleep(1)

        let button = app.buttons["Да"]
        
        var ifAlertExists = app.alerts.firstMatch.exists
        
        print("IfAlert")
        print(ifAlertExists)
        
        for var i in 0...9 {
            
            button.tap()
            
            sleep(3)
            
            i += 1
        }
        
        
        let alert = app.alerts.firstMatch
        
        if alert.exists {
            
            print("Alert Label: \(alert.label)")
            print("Alert Button: \(alert.buttons.firstMatch.label)")
            
        }
       
        sleep(4)
    }
}
