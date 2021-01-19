//
//  GameScene.swift
//  Challenge6
//
//  Created by Tiberiu on 02.01.2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bottle: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var timeLeftLabel: SKLabelNode!
    var bulletsLeftLabel: SKLabelNode!
    var reloadLabel: SKLabelNode!
    
    var bulletsLeft = 10 {
        didSet {
            bulletsLeftLabel.text = "Bullets: \(bulletsLeft)"
        }
    }
    
    var timeLeft = 60 {
        didSet {
            timeLeftLabel.text = "\(timeLeft) seconds remaning"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var bottleGenerator: Timer?
    var gameTimer: Timer?
    
    override func didMove(to view: SKView) {
        let soundAction = SKAction.playSoundFileNamed("bar sound.mp3", waitForCompletion: false)
        run(soundAction)
        backgroundColor = .white
        let background = SKSpriteNode(imageNamed: "bar")
        background.size = CGSize(width: 1024, height: 768)
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontColor = UIColor.red
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: 900, y: 720)
        addChild(scoreLabel)
        
        timeLeftLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        timeLeftLabel.text = "60 seconds remaning"
        timeLeftLabel.fontColor = UIColor.red
        timeLeftLabel.fontSize = 40
        timeLeftLabel.position = CGPoint(x: 210, y: 720)
        addChild(timeLeftLabel)
        
        bulletsLeftLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        bulletsLeftLabel.text = "Bullets: 10"
        bulletsLeftLabel.fontColor = UIColor.red
        bulletsLeftLabel.fontSize = 30
        bulletsLeftLabel.position = CGPoint(x: 100, y: 20)
        addChild(bulletsLeftLabel)
        
        reloadLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        reloadLabel.text = "Reload"
        reloadLabel.fontColor = UIColor.red
        reloadLabel.fontSize = 30
        reloadLabel.position = CGPoint(x: 950, y: 20)
        addChild(reloadLabel)
        
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        startGame()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(reloadLabel) {
            bulletsLeft = 10
            run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
        }
        
        for node in objects {
            if bulletsLeft == 0 {
                return
            }
            
            if node.name == "bottle" {
                //determening how many points the bottle gives based on its size
                if node.frame.size.width == 100 {
                    killBottle(node: node)
                    score += 1
                } else if node.frame.size.width == 70 {
                    killBottle(node: node)
                    score += 2
                } else if node.frame.size.width == 35 {
                    killBottle(node: node)
                    score += 3
                }
            } else if node.name == "redBottle" {
                killBottle(node: node)
                score -= 2
            }
        }
        
    }
    
    func startGame() {
        bottleGenerator = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(generateBottles), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        
    }
    
    func gameOver() {
        bottleGenerator?.invalidate()
        gameTimer?.invalidate()
        
        let gameOverLabel = SKLabelNode(fontNamed: "ArialHebrew-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .red
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        addChild(gameOverLabel)
    }
    
    @objc func timeElapsed() {
        timeLeft -= 1
        
        if timeLeft == 0 {
            gameOver()
        }
    }
    
    @objc func generateBottles() {
        //bottom row
        createBottle(at: 190, size: CGSize(width: 100, height: 250), duration: 3)
        //middle row
        createBottle(at: 420, size: CGSize(width:70, height: 200), duration: 3)
        //top row
        createBottle(at: 590, size: CGSize(width: 35, height: 100), duration: 3)
    }
    
    func createBottle(at yPosition: CGFloat, size: CGSize, duration: TimeInterval) {
        let moveRight = Int.random(in: 1...2)
        let names = ["bottle", "redBottle", "bottle"]
        let name = names.randomElement()
        var xPosition: CGFloat
        var toPosition: CGFloat
        
        switch moveRight {
        case 1:
            xPosition = -200
            toPosition = 1250
        default:
            xPosition = 1200
            toPosition = -250
        }
        
        bottle = SKSpriteNode(imageNamed: name ?? "bottle")
        bottle.position = CGPoint(x: xPosition, y: yPosition)
        bottle.size = size
        bottle.name = name
        bottle.physicsBody = SKPhysicsBody(rectangleOf: bottle.size)
        bottle.physicsBody?.isDynamic = false
        addChild(bottle)
        bottle.run(SKAction.moveTo(x: toPosition, duration: duration))
    }
    
    func killBottle(node: SKNode) {
        let boom = SKEmitterNode(fileNamed: "explosion")!
        bulletsLeft -= 1
        boom.position = node.position
        boom.particleSize = node.frame.size
        addChild(boom)
        run(SKAction.playSoundFileNamed("gun.wav", waitForCompletion: false))
        
        node.removeFromParent()

    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -200 || node.position.x > 1201 {
                node.removeFromParent()
            }
        }
    }
    
}
