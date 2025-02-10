//
//  HomeViewController.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/7/25.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Viewer"
        view.backgroundColor = .white
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.addSubview(usernameTextField)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            usernameTextField.widthAnchor.constraint(equalToConstant: 300),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func searchButtonTapped() {
        let username = usernameTextField.text ?? ""
        
        if username.isEmpty {
            showAlert(message: "Please enter a username")
            return
        }
        
        fetchUserProfile(username: username)
    }
    
    // MARK: - Alert Handling
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Network Request
    private func fetchUserProfile(username: String) {
        let userUrlString = "https://api.github.com/users/\(username)"
        let reposUrlString = "https://api.github.com/users/\(username)/repos"
        
        guard let userUrl = URL(string: userUrlString),
              let reposUrl = URL(string: reposUrlString) else {
            print("Invalid URL")
            return
        }
        
        let userTask = URLSession.shared.dataTask(with: userUrl) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "A network error has occurred: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                
                let reposTask = URLSession.shared.dataTask(with: reposUrl) { data, response, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showAlert(message: "A network error has occurred: \(error.localizedDescription)")
                        }
                        return
                    }
                    
                    guard let data = data else { return }
                    
                    do {
                        let repos = try JSONDecoder().decode([Repo].self, from: data)
                        DispatchQueue.main.async {
                            self.navigateToProfileDetailScreen(user: user, repos: repos)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showAlert(message: "User not found or unable to parse data.")
                        }
                    }
                }
                reposTask.resume()
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(message: "User not found or unable to parse data.")
                }
            }
        }
        userTask.resume()
    }
    
    // MARK: - Navigation
    private func navigateToProfileDetailScreen(user: User, repos: [Repo]) {
        let profileDetailVC = ProfileDetailViewController(user: user, repos: repos)
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }
}
