//
//  ProfileDetailsViewModel.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import Foundation

protocol ProfileLoaderProtocol: AnyObject {
    func shouldChangeImage(byData: Data)
}

final class ProfileDetailsViewModel: NSObject {
    
    private var projects: [Project]
    private(set) var profileName: String
    
    weak var loadDelegate: ProfileLoaderProtocol?
    
    // MARK: - Initialization functions
    
    init(profileName: String, repositories: [Project]) {
        self.projects = repositories
        self.profileName = profileName
    }
    
    func fetchProfileImage() {
        guard let avatarUrl = self.projects.first(where: {$0.avatarUrl != nil})?.avatarUrl, let url = URL(string: avatarUrl) else {
            return
        }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            self.loadDelegate?.shouldChangeImage(byData: data)
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - Table population functions
    
    func numberOfProjects() -> Int {
        return projects.count
    }
    
    func project(for index: Int) -> (name: String, language: String) {
        guard projects.count > index else {
            return ("Error", "Error")
        }
        let repoForIndex = projects[index]
        return (repoForIndex.name ?? "No name found", repoForIndex.language ?? "No language specified")
    }
    
}
