//
//  ViewController.swift
//  Challenge3HangMan
//
//  Created by Tiberiu on 14.12.2020.
//

import UIKit

class ViewController: UIViewController {
    var words = [String]()
    var correctAnswer = String()
    var usedLetters = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var deathScore = 7 {
        didSet {
            deathLabel.text = "You die in: \(deathScore)"
        }
    }
    
    var scoreLabel: UILabel!
    var wordLabel: UILabel!
    var deathLabel: UILabel!
    var currentAnswer: UITextField!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:231/255, green:255/255, blue: 158/255, alpha:1.0)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        deathLabel = UILabel()
        deathLabel.translatesAutoresizingMaskIntoConstraints = false
        deathLabel.textAlignment = .left
        deathLabel.text = "You die in: \(deathScore)"
        view.addSubview(deathLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 24)
        wordLabel.text = "Placeholder"
        view.addSubview(wordLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 24)
        currentAnswer.placeholder = "Guess a letter"
        view.addSubview(currentAnswer)
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -10),
            deathLabel.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            deathLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 30),
            wordLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 30),
            currentAnswer.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -40),
            
            submitButton.centerYAnchor.constraint(equalTo: currentAnswer.layoutMarginsGuide.centerYAnchor),
            submitButton.leadingAnchor.constraint(equalTo: currentAnswer.trailingAnchor, constant: 20)

        ])
        
    }
    

    func loadWords() {
        score = 0
        deathScore = 7
        var placeHolder = ""
        
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                words = startWords.components(separatedBy: "\n")
            }
        }
        words.shuffle()
        correctAnswer = words[0]
        
        for _ in correctAnswer {
            placeHolder.append("?")
        }
        
        wordLabel.text = placeHolder
        print(words)
        print(correctAnswer)
    }
    
    @objc func submitTapped() {
        var promptWord = ""
        guard let answer = currentAnswer.text else { return }
        usedLetters.append(answer.lowercased())
        
        if answer.count != 1 {
            currentAnswer.text?.removeAll()
            currentAnswer.placeholder = "One character is needed, mate!"
        }
        
        for letter in correctAnswer {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        
        if !correctAnswer.contains(answer.lowercased()) {
            deathScore -= 1
            
            if deathScore < 1 {
                goHome()
            }
        } else {
            score += 1
        }
        
        wordLabel.text = promptWord
        
        if let checkLabel = wordLabel.text {
            if !checkLabel.contains("?") {
                congratulate()
            }
        }
        currentAnswer.text?.removeAll()
    }
    
    func congratulate() {
        currentAnswer.text?.removeAll()
        
        let ac = UIAlertController(title: "Congratulations!", message: "You won!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Replay", style: .default))
        present(ac, animated: true, completion: loadWords)
    }
    
    func goHome() {
        let ac = UIAlertController(title: "Better luck next time!", message: "You lost!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Replay", style: .default))
        present(ac, animated: true, completion: loadWords)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
    

    }
}

