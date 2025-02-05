//
//  SearchProfileViewModel.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import Foundation

protocol LoadableProtocol: AnyObject {
    func isLoading()
    func alreadyLoaded<T>(_ dataLoaded: T)
    func loadError(_ error: Error)
}

final class SearchProfileViewModel: NSObject {
    
    weak var loadingDelegate: LoadableProtocol?
    
    let apiClient: RequestExecuter
    
    init(apiClient: RequestExecuter) {
        self.apiClient = apiClient
    }
    
    func fetchProfile(name: String) {
        self.loadingDelegate?.isLoading()
        
        let repoRouter = Router(profileName: name, context: .repositories)
        
        apiClient.execute(router: repoRouter) { [unowned self] (result: Result<[Project], Error>) in
            switch result {
            case .success(let repositories):
                self.loadingDelegate?.alreadyLoaded(repositories)
                break
            case .failure(let error):
                self.loadingDelegate?.loadError(error)
                break
            }
        }
    }
    
}
