//
//  ViewController.swift
//  Project2
//
//  Created by Tiberiu on 02.12.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionNumber = 0
    var message = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()

        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        title! += " \(score)"
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        questionNumber += 1
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
            message = "Your score is \(score)"

        } else {
            title = "Wrong"
            score -= 1
            message = "That's the flag of \(countries[sender.tag].uppercased())"
        }
        
        if questionNumber < 10 {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            let finalAc = UIAlertController(title: "Game over!", message: "You scored \(score)", preferredStyle: .alert)
            finalAc.addAction(UIAlertAction(title: "Bye", style: .destructive))
            present(finalAc, animated: true)
        }
    }
    
    @objc func showScore() {
        var message: String {
            if score == 1 {
                return "I scored 1 point"
            } else {
                return "I scored \(score) points"
            }
        }
        let vc = UIAlertController(title: "Current score: ", message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Resume", style: .default))
        present(vc, animated: true, completion: nil)
    }

}

