//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Илья Ануфриев on 12.01.2025.
//

import XCTest

@testable import MovieQuiz

final class ArrayTest: XCTestCase {
    func testGetValueInRanger() throws {
        
        let array = [1,1,2,3,5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
        
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1,1,2,3,5]
        
        let value = array[safe: 20]
        
        XCTAssertNil(value)
    }
}


