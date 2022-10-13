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
    
    func testNowPlaying() throws {
        
        let expectation = self.expectation(description: "nowplaying")
        
        let testBundle = Bundle(for: type(of: self))
        
        let genere = MovieResp.loadFromFile(testBundle: testBundle,filename: "NowPlaying.json")
        var movieResp: MovieResp!
        networkService.responses["/3/movie/now_playing"] = genere
        useCase.nowPlayingList(page: 1).sink { _ in
            
        } receiveValue: { value in
            movieResp = value
            expectation.fulfill()
        } .store(in: &cancellables)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(movieResp)
        XCTAssertTrue(movieResp.results.count > 0)
        
    }
    
    func testNowPlayingLastPage() throws {
        
        let expectation = self.expectation(description: "nowplaying")
        
        let testBundle = Bundle(for: type(of: self))
        
        let file = MovieResp.loadFromFile(testBundle: testBundle,filename: "NowPlaying.json")
        var movieResp: MovieResp!
        networkService.responses["/3/movie/now_playing"] = file
        useCase.nowPlayingList(page: 100).sink { _ in
            
        } receiveValue: { value in
            movieResp = value
            expectation.fulfill()
        } .store(in: &cancellables)
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(movieResp)
        XCTAssertTrue(movieResp.results.count > 0)
        
    }
    
    
    
    func testNowPlayingModel() throws {
        
        let expectation = self.expectation(description: "NowPlayingModel")
        
        let testBundle = Bundle(for: type(of: self))
        let file = MovieResp.loadFromFile(testBundle: testBundle,filename: "NowPlaying.json")
        var stage = true
        networkService.responses["/3/movie/now_playing"] = file
        
        let model = NowPlayingViewModel(useCase: useCase)
        let input: PassthroughSubject<NowPlayingViewModel.Input,Never> = .init()
        let output = model.transform(input: input.eraseToAnyPublisher())
        output.sink { event in
            switch event {
            case .newData(let data):
                XCTAssertTrue(data.count > 0)
                expectation.fulfill()
            case .loading(loaded: let loaded):
                XCTAssertEqual(loaded, stage)
                stage = !stage
            case .failure(error: let error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        
        
        input.send(.appear)
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(model.shouldLoadNext)
        
    }
    
    func testNowPlayingModelShouldNotLoadNext() throws {
        
        let expectation = self.expectation(description: "NowPlayingModel")
        
        let testBundle = Bundle(for: type(of: self))
        let file = MovieResp.loadFromFile(testBundle: testBundle,filename: "NowPlaying.json")
        var stage = true
        networkService.responses["/3/movie/now_playing"] = file
        
        let model = NowPlayingViewModel(useCase: useCase)
        model.page = 100
        let input: PassthroughSubject<NowPlayingViewModel.Input,Never> = .init()
        let output = model.transform(input: input.eraseToAnyPublisher())
        output.sink { event in
            switch event {
            case .newData(let data):
                XCTAssertTrue(data.count > 0)
                expectation.fulfill()
            case .loading(loaded: let loaded):
                XCTAssertEqual(loaded, stage)
                stage = !stage
            case .failure(error: let error):
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            }
        }.store(in: &cancellables)

        
        
        input.send(.appear)
        self.waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(model.shouldLoadNext)
        
    }
    
    
    func testPerformance() throws {
        // This is an example of a performance test case.
        self.measure {
            
            let testBundle = Bundle(for: type(of: self))
            let genere = Genre.loadFromFile(testBundle: testBundle,filename: "Genre.json")
            
            let ids = [9648,878,37,16,99]
            let _ = ids.map {genere.nameFrom(id: $0)}
            
            
        }
    }
    
}




