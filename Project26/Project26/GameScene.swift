//
//  GameScene.swift
//  Project26
//
//  Created by Tiberiu on 13.01.2021.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint? //this is for testing in the simulator
    var isGameOver = false
    var motionManager: CMMotionManager!
    var scoreLabel: SKLabelNode!
    var firstPortalLocation: CGPoint?
    var secondPortalLocation: CGPoint?
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    
    override func didMove(to view: SKView) {
        loadBackground()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        loadLevel()
        createPlayer()
    }
    
    func loadBackground() {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    //next 4 methods are for testing in the simulator
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
            if let currentTouch = lastTouchPosition {
                let diff = CGPoint(x: currentTouch.x - player.position.x, y: currentTouch.y - player.position.y)
                physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
            }
        #else
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -15, dy: accelerometerData.acceleration.x * 15)
        }
        #endif
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            //challenge 2
            changeLevel()
            //challenge 3
        } else if node.name == "firstPortal" {
            //teleport the player...
            if let secondPortalLocation = secondPortalLocation {
                player.run(SKAction.move(to: CGPoint(x: secondPortalLocation.x + 70, y: secondPortalLocation.y), duration: 0.001))
            }
        } else if node.name == "secondPortal" {
            if let firstPortalLocation = firstPortalLocation {
                player.run(SKAction.move(to: CGPoint(x: firstPortalLocation.x - 70, y: firstPortalLocation.y), duration: 0.001))
            }
        }
    }
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.portal.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    func loadLevel() {
        //challenge 2 - we have only 2 levels :(
        if level > 2 {
            level = 2
        }
        guard let levelURL = Bundle.main.url(forResource: "level" + "\(level)", withExtension: "txt") else {
            fatalError("Could not find level1.txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level" + "\(level)" + ".txt from the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                if letter == "x" {
                    //load wall
                    createWalls(position: position)
                    
                } else if letter == "v" {
                    //load vortex
                    createVortex(position: position)
                    
                } else if letter == "s" {
                    //load star
                    createStars(position: position)
                    
                } else if letter == "f" {
                    //load finish
                    createFinishFlag(position: position)
                    
                } else if letter == " " {
                    //this is an empty space, do nothing.
                } else if letter == "p" {
                    //load first portal
                    createFirstPortal(position: position)
                } else if letter == "P" {
                    //load second portal
                    createSecondPortal(position: position)
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
        
    }
    //challenge 2
    func changeLevel() {
        player.physicsBody?.isDynamic = false
        player.removeFromParent()
        level += 1
        self.removeAllChildren()
        loadBackground()
        loadLevel()
        createPlayer()
    }
    
    func createWalls(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func createVortex(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func createStars(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func createFinishFlag(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    //challenge 3
    func createFirstPortal(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "firstPortal"
        node.size = CGSize(width: 130, height: 130)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 4)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
        
        firstPortalLocation = node.position
    }
    
    func createSecondPortal(position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.name = "secondPortal"
        node.size = CGSize(width: 130, height: 130)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 4)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
        
        secondPortalLocation = node.position
    }
    
}
