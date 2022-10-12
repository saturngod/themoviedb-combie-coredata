//
//  TheMoviesDBTests.swift
//  TheMoviesDBTests
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import XCTest
import Combine
@testable import TheMoviesDB

final class TheMoviesDBTests: XCTestCase {
    
    let networkService = NetworkServiceTypeMock()
    var useCase: MovieUseCase!
    private var cancellables: [AnyCancellable] = []
    
    override func setUp() {
        useCase = MovieUseCase(networkService: networkService)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSplashModel() throws {
        
        let expectation = self.expectation(description: "SplashModel")
        
        let testBundle = Bundle(for: type(of: self))
        let genere = Genre.loadFromFile(testBundle: testBundle,filename: "Genre.json")
        var stage = true
        networkService.responses["/3/genre/movie/list"] = genere
        
        let model = SplashViewModel(useCase: useCase)
        let input: PassthroughSubject<SplashViewModel.Input,Never> = .init()
        let output = model.transform(input: input.eraseToAnyPublisher())
        output.sink { event in
            switch event {
            case .loading(let loaded):
                XCTAssertEqual(loaded, stage)
                stage = !stage
            case .success(let genre):
                XCTAssertNotNil(genre)
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }.store(in: &cancellables)
        
        
        input.send(.appear)
        self.waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    func testGenre() throws {
        
        let expectation = self.expectation(description: "genre")
        
        let testBundle = Bundle(for: type(of: self))
        
        let genere = Genre.loadFromFile(testBundle: testBundle,filename: "Genre.json")
        var genreList: Genre!
        networkService.responses["/3/genre/movie/list"] = genere
        useCase.genreList().sink { _ in
            
        } receiveValue: { value in
            genreList = value
            expectation.fulfill()
        } .store(in: &cancellables)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(genreList)
        XCTAssertTrue(genreList.genres.count > 0)
    }
    
    func testGenereFail() throws {
        let expectation = self.expectation(description: "genre")
        
        var genreList: Genre!
        networkService.responses["/3/genre/movie/list"] = NetworkError.invalidRequest
        useCase.genreList().sink { completion in
            
            if case .failure(let error) = completion {
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            
        } receiveValue: { value in
            genreList = value
            expectation.fulfill()
        } .store(in: &cancellables)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(genreList)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}




