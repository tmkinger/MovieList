//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Tarun Mukesh Kinger on 15/02/20.
//  Copyright © 2020 Tarun Mukesh Kinger. All rights reserved.
//

import XCTest
@testable import MovieList

class MovieListTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMoviesResponse() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "Movies", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        let decoder = JSONDecoder()
        guard let movies = try? decoder.decode(Movies.self, from: data) else {
            return
        }
        
        XCTAssertEqual(movies.movies[0].movieTitle, "Avengers:Age of Ultron ")
        XCTAssertEqual(movies.movies[0].year, "2015 ")
        XCTAssertEqual(movies.movies[0].runTime, "141 min ")
        XCTAssertEqual(movies.movies[0].director, "Joss Whedon ")
    }
    
}
