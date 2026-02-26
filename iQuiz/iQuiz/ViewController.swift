//
//  ViewController.swift
//  iQuiz
//
//  Created by Arkita Jain on 2/15/26.
//

//
//  SettingsViewController.swift
//  iQuiz
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    let urlTextField = UITextField()
    let checkNowButton = UIButton(type: .system)
    let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        setupUI()
        loadSavedSettings()
    }
    func setupUI() {
        
        urlTextField.placeholder = "Enter Quiz JSON URL"
        urlTextField.borderStyle = .roundedRect
        urlTextField.autocapitalizationType = .none
        urlTextField.autocorrectionType = .no
        
        checkNowButton.setTitle("Check Now", for: .normal)
        checkNowButton.addTarget(self,
                                 action: #selector(checkNowTapped),
                                 for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [
            urlTextField,
            checkNowButton
        ])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func loadSavedSettings() {
        let savedURL = UserDefaults.standard.string(forKey: "quizURL") ?? defaultURL
        urlTextField.text = savedURL
    }
    
    func saveURL(_ url: String) {
        UserDefaults.standard.set(url, forKey: "quizURL")
    }
    @objc func checkNowTapped() {
        
        guard let urlString = urlTextField.text,
              !urlString.isEmpty else {
            return
        }
        
        saveURL(urlString)
        
        NetworkManager.shared.fetchQuizzes(from: urlString) { result in
            
            switch result {
                
            case .success(let quizzes):
                print("The quizzes downloaded: ", quizzes)
                
            case .failure:
                self.showNetworkError()
            }
        }
    }
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Network Error",
            message: "Unable to download quizzes. Please check your internet connection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
