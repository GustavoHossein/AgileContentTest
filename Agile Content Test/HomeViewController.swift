//
//  HomeViewController.swift
//  Agile Content Test
//
//  Created by Gustavo Hossein on 2/7/25.
//

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
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Github Viewer"
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(usernameTextField)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25),
            usernameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            searchButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 25),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func searchTapped() {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        let profileVC = ProfileViewController(username: username)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}
