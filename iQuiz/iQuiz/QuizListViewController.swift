//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Arkita Jain on 2/15/26.
//

import Foundation
import UIKit


struct Quiz {
    let title: String
    let description: String
    let icon: String
}


class QuizListViewController: UITableViewController {

    // In-memory array (Part 1 requirement)
    let quizzes: [Quiz] = [
        Quiz(title: "Mathematics",
             description: "Try out some math problems!",
             icon: "plus.slash.minus"),
        
        Quiz(title: "Marvel Super Heroes",
             description: "How big of a Marvel fan are you?",
             icon: "star.fill"),
        
        Quiz(title: "Science",
             description: "Try out some science problems!",
             icon: "flask")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
    }


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
        
        var content = cell.defaultContentConfiguration()
        content.text = quiz.title
        content.secondaryText = quiz.description
        content.image = UIImage(systemName: quiz.icon)

        cell.contentConfiguration = content


        return cell
    }


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
