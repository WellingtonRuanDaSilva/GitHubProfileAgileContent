//
//  GitHubProfileAgileContentTests.swift
//  GitHubProfileAgileContentTests
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import XCTest
@testable import GitHubProfileAgileContent

class MockApi: RequestExecuter {
    
    func execute<T>(router: Router, completion: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        
        var mockedProjectOne = Project()
        mockedProjectOne.name = "John"
        mockedProjectOne.language = "C"
        var mockedProjectTwo = Project()
        mockedProjectTwo.name = "Derg"
        mockedProjectTwo.language = "Swift"
        let projectsMocked: [Project] = [mockedProjectOne, mockedProjectTwo]
        let data = try! JSONEncoder().encode(projectsMocked)
        let responseObject = try! JSONDecoder().decode(T.self, from: data)
        
        completion(.success(responseObject))
    }
    
}

class GithubPopulationTests: XCTestCase {
    
    var searchProfileViewModel: SearchProfileViewModel!
    var profileDetailsViewModel: ProfileDetailsViewModel!
    var projectsMocked: [Project] = []
    
    override func setUp() {
        
        let mockClient = MockApi()
        searchProfileViewModel = SearchProfileViewModel(apiClient: mockClient)
        
        let fetchExpectation = expectation(description: "Fetch")
        
        let repoRouter = Router(profileName: name, context: .repositories)
        
        searchProfileViewModel.apiClient.execute(router: repoRouter) { (result: Result<[Project], Error>) in
            switch result {
            case .success(let repositories):
                XCTAssertNotNil(repositories)
                self.profileDetailsViewModel = ProfileDetailsViewModel(profileName: "mockedname", repositories: repositories)
                fetchExpectation.fulfill()
                break
            case .failure(_):
                XCTFail("Should always load with success")
            }
        }
        
        wait(for: [fetchExpectation], timeout: 3.0)
    }
    
    func testNumberOfRepositoriesFetched() {
        XCTAssert(profileDetailsViewModel.numberOfProjects() == 2)
    }
    
    func testKeywordsAtIndex() {
        XCTAssert(profileDetailsViewModel.project(for: 0).language == "C")
        XCTAssert(profileDetailsViewModel.project(for: 0).name == "John")
        XCTAssert(profileDetailsViewModel.project(for: 1).language == "Swift")
        XCTAssert(profileDetailsViewModel.project(for: 1).name == "Derg")
        XCTAssert(profileDetailsViewModel.project(for: 2) == ("Error", "Error"))
    }
    
}
