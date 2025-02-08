//
//  HomeViewController.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/7/25.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Viewer"
        view.backgroundColor = .white
        setupViews()
    }
    
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
    
    @objc private func searchButtonTapped() {
        let username = usernameTextField.text ?? ""
        
        if username.isEmpty {
            showAlert(message: "Please enter a username")
            return
        }
        
        fetchUserProfile(username: username)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func fetchUserProfile(username: String) {
        let urlString = "https://api.github.com/users/\(username)/repos"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(message: "A network error has occurred: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                // Tenta decodificar os dados dos repositórios
                let repos = try JSONDecoder().decode([Repo].self, from: data)
                DispatchQueue.main.async {
                    // Aqui vamos chamar a navegação para a tela de detalhes
                    self.navigateToProfileDetailScreen(repos: repos, username: username)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(message: "User not found or unable to parse data.")
                }
            }
        }
        task.resume()
    }
    
    private func navigateToProfileDetailScreen(repos: [Repo], username: String) {
        let profileDetailVC = ProfileDetailViewController(repos: repos, username: username)
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }

}
