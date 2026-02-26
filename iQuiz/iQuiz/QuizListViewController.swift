//
//  QuizListViewController.swift
//  iQuiz
//

import UIKit

struct Quiz: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}

struct Question: Codable {
    let text: String
    let answer: String   // IMPORTANT: String, not Int
    let answers: [String]
}


// structure

class QuizListViewController: UITableViewController {
    
    var quizzes: [Quiz] = []

    func loadQuizzes() {
        
        let url = UserDefaults.standard.string(forKey: "quizURL")
            ?? "http://tednewardsandbox.site44.com/questions.json"
        
        NetworkManager.shared.fetchQuizzes(from: url) { result in
            
            switch result {
                
            case .success(let downloadedQuizzes):
                self.quizzes = downloadedQuizzes
                self.tableView.reloadData()
                
            case .failure:
                print("Failed to load quizzes")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        
        loadQuizzes()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    @objc func openSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "QuizCell",
            for: indexPath
        )
        // DISPLAYYY
        let quiz = quizzes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = quiz.title
        
        // description and title from part 1
        content.secondaryText = quiz.desc
        
        
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        let quizVC = QuizViewController()
        quizVC.quiz = quizzes[indexPath.row]
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

// quiz screen

class QuizViewController: UIViewController {
    
    var quiz: Quiz!
    
    var currentQuestionIndex = 0
    var score = 0
    var selectedAnswerInt: Int?
    
    var showingAnswer = false
    var isFinished = false
    
    let questionLabel = UILabel()
    let answersStackView = UIStackView()
    let mainButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = quiz.title
        
        setupUI()
        showQuestion()
    }
    
// display
    
    func setupUI() {
        
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        
        answersStackView.axis = .vertical
        answersStackView.spacing = 12
        
        mainButton.addTarget(self,
                             action: #selector(mainButtonTapped),
                             for: .touchUpInside)
        
        let mainStack = UIStackView(arrangedSubviews: [
            questionLabel,
            answersStackView,
            mainButton
        ])
        
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
// question scene
    func showQuestion() {
        
        showingAnswer = false
        isFinished = false
        selectedAnswerInt = nil
        
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        
        mainButton.setTitle("Submit", for: .normal)
        
        answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<question.answers.count {
            let button = UIButton(type: .system)
            button.setTitle(question.answers[i], for: .normal)
            button.tag = i
            button.addTarget(self,
                             action: #selector(answerTapped(_:)),
                             for: .touchUpInside)
            answersStackView.addArrangedSubview(button)
        }
    }
    
// answer scene
    func showAnswer() {
        
        showingAnswer = true
        
        let question = quiz.questions[currentQuestionIndex]
        
        // Convert JSON string answer to zero-based Int
        guard let correctIndex = Int(question.answer).map({ $0 - 1 }) else {
            questionLabel.text = "Error determining correct answer."
            return
        }
        
        if selectedAnswerInt == correctIndex {
            score += 1
            questionLabel.text = "Correct!\n\nAnswer: \(question.answers[correctIndex])"
        } else {
            questionLabel.text = "Incorrect.\n\nCorrect answer: \(question.answers[correctIndex])"
        }
        
        answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainButton.setTitle("Next", for: .normal)
    }
// score scene
    
    func showFinishedScreen() {
        
        isFinished = true
        
        let total = quiz.questions.count
        
        var message = ""
        
        if score == total {
            message = "Awesome work!"
        } else if score > total / 2 {
            message = "Almost there!"
        } else {
            message = "Yikes! That was rough."
        }
        
        questionLabel.text = "\(message)\n\nScore: \(score) of \(total)"
        
        answersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainButton.setTitle("Back to Topics", for: .normal)
    }
    
// buttons
    
    @objc func answerTapped(_ sender: UIButton) {
        selectedAnswerInt = sender.tag
    }
    
    @objc func mainButtonTapped() {
        
        if isFinished {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        if showingAnswer {
            
            currentQuestionIndex += 1
            
            if currentQuestionIndex < quiz.questions.count {
                showQuestion()
            } else {
                showFinishedScreen()
            }
            
        } else {
            
            if selectedAnswerInt != nil {
                showAnswer()
            }
        }
    }
}
