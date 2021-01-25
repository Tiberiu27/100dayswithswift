//
//  GameViewController.swift
//  Project29
//
//  Created by Tiberiu on 19.01.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene!
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "Score: \(player1Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "Score: \(player2Score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        angleChanged(angleSlider)
        velocityChanged(velocitySlider)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    //challenge 1
    func showGameOver() {
        //remove all sprites from game
        currentGame.removeAllChildren()
        //hide this view's labels
        playerNumber.isHidden = true
        player1ScoreLabel.isHidden = true
        player2ScoreLabel.isHidden = true
        
        //create and show game over label
        let label = UILabel(frame: CGRect(x: 412, y: 284, width: 400, height: 100))
        label.text = "GameOver"
        label.font = label.font.withSize(44)
        label.textColor = .white
        view.addSubview(label)
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))°"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
