//
//  SearchProfileViewController.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import UIKit

class SearchProfileViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var profileSearchBar: UISearchBar!{
        didSet{
            profileSearchBar.searchTextField.textColor = .black
        }
    }
    
    private let viewModel: SearchProfileViewModel

    init() {
        self.viewModel = SearchProfileViewModel(apiClient: Requester())
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.viewModel.loadingDelegate = self
    }
    
    @IBAction func searchProfilePressed(_ sender: Any) {
        guard let name = profileSearchBar.text else {
            return
        }
        viewModel.fetchProfile(name: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchProfileViewController: LoadableProtocol {
    
    func isLoading() {
        DispatchQueue.main.async {
            Spinner.start(from: self.view)
        }
    }
    
    func alreadyLoaded<T>(_ dataLoaded: T) {
        DispatchQueue.main.async {
            Spinner.stop()
            if let name = self.profileSearchBar.text, let repos = dataLoaded as? [Project] {
                self.coordinator?.goToProfileDetails(profileName: name, repositories: repos)
            }
        }
    }
    
    func loadError(_ error: Error) {
        DispatchQueue.main.async {
            Spinner.stop()
//            self.showAlert(title: "User not Found", message: "Please enter another name")
            switch error.localizedDescription {
                case "The request timed out.":
                    self.showAlert(title: "A network error has ocurred", message: "Check your Internet connection and try again later")
                case "server_wrong_error":
                    self.showAlert(title: "A network error has ocurred", message: "Check your Internet connection and try again later")
                case "The Internet connection appears to be offline.":
                    self.showAlert(title: "A network error has ocurred", message: "Check your Internet connection and try again later")
                default:
                    self.showAlert(title: "User not Found", message: "Please enter another name")
                }
        }
    }

}
