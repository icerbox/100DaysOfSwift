//
//  GameScene.swift
//  Milestone_Projects_16-18
//
//  Created by Айсен Еремеев on 22.01.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var bulletLeft: SKLabelNode!
    var ground = SKSpriteNode()
    var topRow = ["BellX1", "GrummanE2Hawkeye"]
    var middleRow = ["CaravelleSE210", "BoeingVC137C", "Saab29Tunnan", "Boeing7478F"]
    var bottomRow = ["McDonnellDouglasDC10", "Su27"]
    var gameTimer: Timer?
    var topRowTimer: Timer?
    var middleRowTimer: Timer?
    var bottomRowTimer: Timer?
    var isReloaded: Bool = true
    var isGameOver: Bool = false
    var topRowTime: Double = Double.random(in: 2.0...5.0)
    var middleRowTime: Double = Double.random(in: 3.0...6.0)
    var bottomRowTime: Double = Double.random(in: 3.0...5.0)
    var restartLabel: SKLabelNode!
    var restartButton: SKNode! = nil
    var backgroundMusic: SKAudioNode!
    
    var time: Double = 1.0

    var roundTime: Double = 60.0 {
        didSet {
            timerLabel.text = "\(Int(roundTime)) seconds"
            if roundTime == 0.0 {
                gameOver()
            }
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bulletCounter = 6 {
        didSet {
            bulletLeft.text = "Bullets left: \(bulletCounter) "
            if bulletCounter == 0 {
                isReloaded = false
            }
        }
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createObjects()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        if let musicUrl = Bundle.main.url(forResource: "airplanes_background", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicUrl)
            addChild(backgroundMusic)
        } else {
            print("Error loading background music")
        }
        
        topRowTimer = Timer.scheduledTimer(timeInterval: topRowTime, target: self, selector: #selector(createTopRowTarget), userInfo: nil, repeats: true)
        
        middleRowTimer = Timer.scheduledTimer(timeInterval: middleRowTime, target: self, selector: #selector(createMiddleRowTarget), userInfo: nil, repeats: true)
        
        bottomRowTimer = Timer.scheduledTimer(timeInterval: bottomRowTime, target: self, selector: #selector(createBottomRowTarget), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            for node in touchedNode {
                if node.name == "Reloader" {
                    run(SKAction.playSoundFileNamed("reload.caf", waitForCompletion: false))
                    bulletCounter = 6
                    isReloaded = true
                }
                if isReloaded  == true {
                    if node.name == "BellX1" || node.name == "GrummanE2Hawkeye" || node.name == "Saab29Tunnan" || node.name == "Su27" {
                        run(SKAction.playSoundFileNamed("crush.caf", waitForCompletion: false))
                        explosion.position = node.position
                        addChild(explosion)
                        node.removeFromParent()
                        score += 1
                        bulletCounter -= 1
                    } else if node.name == "CaravelleSE210" || node.name == "BoeingVC137C" || node.name == "Boeing7478F" || node.name == "McDonnellDouglasDC10" {
                        run(SKAction.playSoundFileNamed("fail.caf", waitForCompletion: false))
                        node.removeFromParent()
                        score -= 1
                        bulletCounter -= 1
                    }
                } else {
                    run(SKAction.playSoundFileNamed("noammo.caf", waitForCompletion: false))
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if isGameOver {
            print("isGameOver: \(isGameOver)")
            for touch in touches {
                let location = touch.location(in: self)
                
                guard let restartButton = restartButton else { return }
                if restartButton.contains(location) {
                    print("Restarting game")
                    restartGame()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveGrounds()
        moveClouds()
        
        for node in children {
            if node.name == "Ground" {
            } else if node.name == "Cloud" {
            } else {
                if node.position.x < -600 || node.position.x > 1200 {
                    node.removeFromParent()
                }
            }
        }
    }
    
    @objc func createTopRowTarget() {
        guard let enemy = topRow.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.isUserInteractionEnabled = false
        sprite.name = enemy
        sprite.zPosition = 10
        sprite.position = CGPoint(x: -500, y: Int.random(in: 200...250))
        sprite.size = CGSize(width: sprite.size.width / 2, height: sprite.size.height / 2)
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: 1024, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularVelocity = 0

        topRowTimer?.invalidate()
        
        topRowTimer = Timer.scheduledTimer(timeInterval: topRowTime, target: self, selector: #selector(createTopRowTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createMiddleRowTarget() {
        guard let enemy = middleRow.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.isUserInteractionEnabled = false
        sprite.name = enemy
        sprite.zPosition = 10
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 0...150))
        sprite.size = CGSize(width: sprite.size.width / 2, height: sprite.size.height / 2)
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularVelocity = 0
        
        middleRowTimer?.invalidate()
        
        middleRowTimer = Timer.scheduledTimer(timeInterval: middleRowTime, target: self, selector: #selector(createMiddleRowTarget), userInfo: nil, repeats: true)
    }
    
    @objc func createBottomRowTarget() {
        guard let enemy = bottomRow.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.isUserInteractionEnabled = false
        sprite.name = enemy
        sprite.zPosition = 10
        sprite.position = CGPoint(x: -500, y: Int.random(in: -200...(-50)))
        sprite.size = CGSize(width: sprite.size.width / 2, height: sprite.size.height / 2)
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: 1024, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularVelocity = 0
        
        bottomRowTimer?.invalidate()
        
        bottomRowTimer = Timer.scheduledTimer(timeInterval: bottomRowTime, target: self, selector: #selector(createBottomRowTarget), userInfo: nil, repeats: true)
    }
    
    @objc func gameOver() {
        isGameOver = true
        gameTimer?.invalidate()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 0, y: 0)
        addChild(gameOver)
        run(SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: true))
        
        restartButton = SKSpriteNode(texture: .none, size: CGSize(width: 300, height: 50))
        restartButton.position = CGPoint(x: 0, y: 50)
        restartButton.zPosition = 10
        addChild(restartButton)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart game"
        restartLabel.horizontalAlignmentMode = .center
        restartLabel.isHidden = false
        restartLabel.zPosition = 11
        
        restartButton.addChild(restartLabel)
        
    
        topRowTimer?.invalidate()
        middleRowTimer?.invalidate()
        bottomRowTimer?.invalidate()
    }
    
    @objc func changeTime() {
        roundTime -= 1
    }
    
    func createObjects() {
        for i in 0...3 {
            let ground = SKSpriteNode(imageNamed: "background")
            ground.name = "Ground"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 768)
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: 0)
            ground.zPosition = -5
            self.addChild(ground)
        }
        
        for i in 0...2 {
            let cloud = SKSpriteNode(imageNamed: "cloud1")
            cloud.name = "Cloud"
            cloud.size = CGSize(width: self.size.width / 3, height: self.size.height / 3)
            cloud.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cloud.position = CGPoint(x: CGFloat(i) * cloud.size.width, y: CGFloat(Float.random(in: 0...300)))
            cloud.zPosition = -4
            self.addChild(cloud)
        }
        
        let reloader = SKSpriteNode(imageNamed: "reload")
        reloader.name = "Reloader"
        reloader.size = CGSize(width: reloader.size.width, height: reloader.size.height)
        reloader.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        reloader.position = CGPoint(x: 0, y: -320)
        reloader.zPosition = 1000
        reloader.isUserInteractionEnabled = false
        self.addChild(reloader)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 300, y: 320)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = -3
        score = 0
        addChild(scoreLabel)
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 0, y: 320)
        timerLabel.horizontalAlignmentMode = .left
        timerLabel.zPosition = -3
        addChild(timerLabel)
        
        roundTime = 60.0
        
        bulletLeft = SKLabelNode(fontNamed: "Chalkduster")
        bulletLeft.position = CGPoint(x: 500, y: -340)
        bulletLeft.horizontalAlignmentMode = .right
        bulletLeft.zPosition = -3
        bulletLeft.text = "Bullets left: \(bulletCounter)"
        
        addChild(bulletLeft)
    }
    
    func moveClouds() {
        self.enumerateChildNodes(withName: "Cloud", using: ({
            (node, error) in
            node.position.x -= 2
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 2
            }
        }))
    }
    
    func moveGrounds() {
        self.enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            node.position.x -= 1
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
            }
        }))
    }
    
    func restartGame() {
        isGameOver = false
        removeAllChildren()
        gameTimer?.invalidate()
        topRowTimer?.invalidate()
        middleRowTimer?.invalidate()
        bottomRowTimer?.invalidate()
        roundTime = 60.0
        bulletCounter = 6
        score = 0
        isReloaded = true
        
        backgroundColor = SKColor.white
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        createObjects()
        
        topRowTimer = Timer.scheduledTimer(timeInterval: topRowTime, target: self, selector: #selector(createTopRowTarget), userInfo: nil, repeats: true)
        
        middleRowTimer = Timer.scheduledTimer(timeInterval: middleRowTime, target: self, selector: #selector(createMiddleRowTarget), userInfo: nil, repeats: true)
        
        bottomRowTimer = Timer.scheduledTimer(timeInterval: bottomRowTime, target: self, selector: #selector(createBottomRowTarget), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(changeTime), userInfo: nil, repeats: true)
        
        if let musicUrl = Bundle.main.url(forResource: "airplanes_background", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicUrl)
            addChild(backgroundMusic)
        } else {
            print("Error loading background music")
        }
    }
}
