//
//  TheMoviesDBTests.swift
//  TheMoviesDBTests
//
//  Created by Htain Lin Shwe on 11/10/2022.
//

import XCTest
import Combine
@testable import TheMoviesDB


final class NetworkServiceTypeMock: NetworkServiceType {
    var responses = [String:Any]()
    
    func load<T>(_ resource: Resource<T>) -> AnyPublisher<T, Error> {
        print(resource.url.path)
        if let response = responses[resource.url.path] as? T {
            return Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else if let error = responses[resource.url.path] as? NetworkError {
            return Fail(error:error).eraseToAnyPublisher()
        } else {
            return Fail(error:NetworkError.invalidRequest).eraseToAnyPublisher()
        }
    }
}



extension Decodable {
    static func loadFromFile(testBundle: Bundle, filename: String) -> Self {
        do {
            
            let path = testBundle.path(forResource: filename, ofType: nil)!
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}

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
        
        let testBundle = Bundle(for: type(of: self))
        
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




