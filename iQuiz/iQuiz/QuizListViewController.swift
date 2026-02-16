//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Arkita Jain on 2/15/26.
//

import Foundation
import UIKit

// MARK: - Model

struct Quiz {
    let title: String
    let description: String
    let iconName: String
}

// MARK: - View Controller

class QuizListViewController: UITableViewController {

    // In-memory array (Part 1 requirement)
    let quizzes: [Quiz] = [
        Quiz(title: "Mathematics",
             description: "Test your math skills.",
             iconName: "function"),
        
        Quiz(title: "Marvel Super Heroes",
             description: "How well do you know Marvel?",
             iconName: "bolt.fill"),
        
        Quiz(title: "Science",
             description: "Explore scientific facts.",
             iconName: "atom")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        
        // Settings button in top toolbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
    }

    // MARK: - TableView Data Source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "QuizCell",
            for: indexPath
        )

        let quiz = quizzes[indexPath.row]

        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.description
        cell.imageView?.image = UIImage(systemName: quiz.iconName)

        return cell
    }

    // MARK: - Settings Alert

    @objc func showSettings() {
        let alert = UIAlertController(
            title: "Settings",
            message: "Settings go here",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default
        ))

        present(alert, animated: true)
    }
}
