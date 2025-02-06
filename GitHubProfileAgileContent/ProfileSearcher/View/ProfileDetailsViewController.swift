//
//  ProfileDetailsViewController.swift
//  GitHubProfileAgileContent
//
//  Created by Wellington Ruan da Silva on 05/02/25.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    
    fileprivate let projectCellId = "projectCell"
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView.round()
        }
    }
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var projectsTableView: UITableView!{
        didSet{
            projectsTableView.register(UITableViewCell.self, forCellReuseIdentifier: projectCellId)
            projectsTableView.dataSource = self
        }
    }
    
    weak var coordinator: MainCoordinator?
    
    private let viewModel: ProfileDetailsViewModel

    init(with viewModel: ProfileDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: .main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.loadDelegate = self
        self.viewModel.fetchProfileImage()
        profileNameLabel.text = viewModel.profileName
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProjects()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: projectCellId, for: indexPath) as UITableViewCell
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: projectCellId)
        }
        cell.backgroundColor = .white
        let projectInfo = viewModel.project(for: indexPath.row)
        cell.textLabel?.text = projectInfo.name
        cell.detailTextLabel?.text = projectInfo.language
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black

        return cell
    }
}

extension ProfileDetailsViewController: ProfileLoaderProtocol{
    
    func shouldChangeImage(byData: Data) {
        DispatchQueue.main.async {
            self.profileImageView.image = UIImage(data: byData)
        }
    }
}
