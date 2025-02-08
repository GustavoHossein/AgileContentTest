//
//  ProfileViewController.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/7/25.
//

import Foundation
import UIKit

class ProfileDetailViewController: UIViewController {

    var repos: [Repo] = []
    var username: String = ""

    // UI Elements
    private let usernameLabel = UILabel()
    private let tableView = UITableView()

    init(repos: [Repo], username: String) {
        super.init(nibName: nil, bundle: nil)
        self.repos = repos
        self.username = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        // Setup username label
        usernameLabel.text = "Username: \(username)"
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Setup tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "repoCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = repos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        cell.textLabel?.text = repo.name
        if let language = repo.language {
            cell.detailTextLabel?.text = "Language: \(language)"
        } else {
            cell.detailTextLabel?.text = "Language: Unknown"
        }
        return cell
    }
}



