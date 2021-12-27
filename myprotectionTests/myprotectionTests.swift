//
//  myprotectionTests.swift
//  myprotectionTests
//
//  Created by Rubeg NPO on 15.07.2020.
//  Copyright © 2020 Rubeg NPO. All rights reserved.
//

import XCTest
@testable import myprotection

class MyprotectionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let stringsRotator = Rotator<String>.create(items: ["1", "2", "3"])
        XCTAssertEqual("1", stringsRotator.current)
        XCTAssertEqual("2", stringsRotator.next())
        XCTAssertEqual("2", stringsRotator.current)
        XCTAssertEqual("3", stringsRotator.next())
        XCTAssertEqual("3", stringsRotator.current)
        XCTAssertEqual("1", stringsRotator.next())

        let numbersRotator = stringsRotator.map { (item: String) in Int(item)! }
        XCTAssertEqual(1, numbersRotator.current)
        XCTAssertEqual(2, numbersRotator.next())
        XCTAssertEqual(2, numbersRotator.current)
        XCTAssertEqual(3, numbersRotator.next())
        XCTAssertEqual(3, numbersRotator.current)
        XCTAssertEqual(1, numbersRotator.next())

        let anotherStringRotator = numbersRotator.map { (item: Int) in "\(item)" }
        XCTAssertEqual("1", anotherStringRotator.current)
        XCTAssertEqual("2", anotherStringRotator.next())
        XCTAssertEqual("2", anotherStringRotator.current)
        XCTAssertEqual("3", anotherStringRotator.next())
        XCTAssertEqual("3", anotherStringRotator.current)
        XCTAssertEqual("1", anotherStringRotator.next())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
