//
//  QuizListViewController.swift
//  iQuiz
//

import UIKit

struct Quiz {
    let title: String
    let description: String
    let icon: String
    let questions: [Question]
}

struct Question {
    let text: String
    let answers: [String]
    let correctIndex: Int
}


// structure

class QuizListViewController: UITableViewController {
    
    let quizzes: [Quiz] = [
        
        Quiz(
            title: "Mathematics",
            description: "Try out some math problems!",
            icon: "plus.slash.minus",
            questions: [
                Question(
                    text: "What is [(12^2)*32]/3]",
                    answers: ["3203", "4608", "5429"],
                    correctIndex: 1
                ),
                Question(
                    text: "What is 5 * 9 * 2?",
                    answers: ["80", "100", "90"],
                    correctIndex: 2
                )
            ]
        ),
        
        Quiz(
            title: "Marvel Super Heroes",
            description: "How big of a Marvel fan are you?",
            icon: "star.fill",
            questions: [
                Question(
                    text: "Who plays Tony Stark (aka Iron Man)?",
                    answers: ["Robert Downey Jr", "Bruce Banner", "Chris Evans"],
                    correctIndex: 0
                ),
                Question(
                    text: "What is Thor's Power?",
                    answers: ["Thunder", "Hammer", "Strength"],
                    correctIndex: 0
                ),
                Question(
                    text: "Who is Thor's Brother?",
                    answers: ["Hulk", "Loki", "Black Widow"],
                    correctIndex: 1
                )
            ]
        ),
        
        Quiz(
            title: "Science",
            description: "Try out some science problems!",
            icon: "flask",
            questions: [
                Question(
                    text: "What percentage of the Earth's surface is covered in water?",
                    answers: ["70%", "71%", "72%"],
                    correctIndex: 1
                )
            ]
        )
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iQuiz"
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
        // DISPLAYYY
        let quiz = quizzes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = quiz.title
        
        // description and title from part 1
        content.secondaryText = quiz.description
        content.image = UIImage(systemName: quiz.icon)
        
        
        
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
        let correctIndex = question.correctIndex
        
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
