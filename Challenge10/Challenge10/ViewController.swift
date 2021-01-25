//
//  ViewController.swift
//  Challenge10
//
//  Created by Tiberiu on 22.01.2021.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    let width = 140
    let height = 170
    let spacer = 40
    let tag = 1984
    
    var cards = [UIButton]()
    var content = [String]()
    var matches = [String: String]()
    var firstCard: String?
    var firstCardFlipped = false
    var previousButton: UIButton?

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let cardsContainerView = UIView()
        cardsContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardsContainerView.layer.borderWidth = 1
        cardsContainerView.layer.borderColor = UIColor.green.cgColor
        view.addSubview(cardsContainerView)
        
        NSLayoutConstraint.activate([
            cardsContainerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            cardsContainerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cardsContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -70),
            cardsContainerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 70)
            
        ])
        
        loadCotent()
  
        for row in 0 ..< 4 {
            for col in 0 ..< 4 {
                let randomTitle = content.randomElement()
                content.remove(at: content.firstIndex(of: randomTitle!)!)
                //custom so we can add image to it
                let cardButton = UIButton(type: .custom)
                cardButton.setTitle(randomTitle, for: .normal)
                //crete the cardFront
                let cardFront = createflippedLabel(text: randomTitle!)
                cardFront.tag = tag
                cardButton.addSubview(cardFront)
                cardFront.isHidden = true
                
                //some wierd mesurements so I can obtain a grid with spacing
                let frame = CGRect(x: col * width + 150, y: row * height + 5, width: width - spacer, height: height - spacer)
                cardButton.frame = frame
                if let image = UIImage(named: "cardBack") {
                    cardButton.setImage(image, for: .normal)
                }
                cardButton.layer.borderColor = UIColor.lightGray.cgColor
                cardButton.layer.borderWidth = 1
                cardsContainerView.addSubview(cardButton)
                cards.append(cardButton)
                
                cardButton.addTarget(self, action: #selector(cardTapped), for: .touchUpInside)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func assignFirstCard(card: String) {
        firstCard = card
    }
    
    func loadCotent() {
        if let contentURL = Bundle.main.url(forResource: "content", withExtension: "txt") {
            if let contents = try? String(contentsOf: contentURL) {
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    let words = line.components(separatedBy: " ")
                    //remove the accidental white empty lines from the txt file
                    if words.contains("") {
                        continue
                    }
                    //add to dictionary
                    matches[words[0]] = words[1]
                    content.append(contentsOf: words)
                    
                }
            }
        }
    }

    @objc func cardTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        //test flipping


        if !firstCardFlipped {
            assignFirstCard(card: title)
            previousButton = sender
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.transition(from: sender.imageView!, to: sender.viewWithTag(self.tag)!, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)

            }
            firstCardFlipped = true
        } else {
            //this works with no problem
            if matches[firstCard!] == title || matches[title] == firstCard {
                print("matched!")

                sender.removeFromSuperview()
                previousButton?.removeFromSuperview()
                cards.remove(at: cards.firstIndex(of: sender)!)
                cards.remove(at: cards.firstIndex(of: previousButton!)!)
                if cards.isEmpty {
                    showGameOver()
                }
                previousButton = nil
                firstCardFlipped = false
                firstCard = ""
            } else {
                //stop the user from pressing like a maniac
                self.view.isUserInteractionEnabled = false
                
                guard let lastButton = previousButton else { return }
                
                //flip the current card and flip back
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.transition(from: sender.imageView!, to: sender.viewWithTag(self.tag)!, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.transition(from: sender.viewWithTag(self.tag)!, to: sender.imageView!, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                }
                //flip the previous card back to imageView(the biohazard thing...)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.transition(from: lastButton.viewWithTag(self.tag)!, to: lastButton.imageView!, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                    
                    self.view.isUserInteractionEnabled = true
                }
                previousButton = nil
                firstCardFlipped = false
                firstCard = ""



            }
        }
    }
    

    
    func createflippedLabel(text: String) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 140 - spacer, height: 170 - spacer)
        view.backgroundColor = .white
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.sizeToFit()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
        
        return view
    }

    func showGameOver() {
        let frame = CGRect(x: 512, y: 384, width: 400, height: 200)
        let gameOverLabel = UILabel()
        gameOverLabel.frame = frame
        gameOverLabel.text = "You win!"
        gameOverLabel.font.withSize(50)
        view.addSubview(gameOverLabel)
        
        print("bye")
    }
    
    func save() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let savedData = try? encoder.encode(content) {
            defaults.setValue(savedData, forKey: "content")
        } else {
            print("Failed to save content.")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let savedData = defaults.object(forKey: "content") as? Data {
            do {
                content = try decoder.decode([String].self, from: savedData)
            } catch {
                print("failed to load content.")
            }
        }
    }
}

