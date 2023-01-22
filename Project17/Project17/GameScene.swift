//
//  GameScene.swift
//  Project17
//
//  Created by Айсен Еремеев on 11.01.2023.
//
import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var starfield: SKEmitterNode!
  var player: SKSpriteNode!
  var scoreLabel: SKLabelNode!
  var roundChanged: SKLabelNode!
  var possibleEnemies = ["ball", "hammer", "tv"]
  var possiblePerks = ["blast"]
  var gameTimer: Timer?
  var perkTimer: Timer?
  var time: Double = 1.0
  var isPlayerTouched: Bool = true
  
  var round = 1 {
    didSet {
      roundChanged.text = "Round \(round)"
    }
  }
  
  var enemyCounter = 0 {
    didSet {
      if enemyCounter % 20 == 0 {
        time -= 0.1
        round += 1
        run(SKAction.playSoundFileNamed("roundchanging.caf", waitForCompletion: true))
      }
    }
  }
  var isGameOver = false
  var restartButton: SKNode! = nil
  var restartLabel: SKLabelNode!
  var backgroundMusic: SKAudioNode!
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
    override func didMove(to view: SKView) {
      backgroundColor = .black
      starfield = SKEmitterNode(fileNamed: "starfield")!
      starfield.position = CGPoint(x: 1024, y: 384)
      starfield.advanceSimulationTime(10)
      addChild(starfield)
      starfield.zPosition = -1
      
      player = SKSpriteNode(imageNamed: "player")
      player.name = "Player"
      player.position = CGPoint(x: 100, y: 384)
      player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
      player.physicsBody?.contactTestBitMask = 1
      addChild(player)
            
      if let musicURL = Bundle.main.url(forResource: "background", withExtension: "m4a") {
        backgroundMusic = SKAudioNode(url: musicURL)
        addChild(backgroundMusic)
      } else {
        print("Error loading background music")
      }
      
      scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      scoreLabel.position = CGPoint(x: 16, y: 16)
      scoreLabel.horizontalAlignmentMode = .left
      addChild(scoreLabel)
      
      roundChanged = SKLabelNode(fontNamed: "Chalkduster")
      roundChanged.text = "Round 1"
      roundChanged.position = CGPoint(x: 768, y: 684)
      roundChanged.horizontalAlignmentMode = .left
      addChild(roundChanged)
      
      score = 0
      physicsWorld.gravity = .zero
      physicsWorld.contactDelegate = self
      
      gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
      
      perkTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 10.0...20.0), target: self, selector: #selector(createPerk), userInfo: nil, repeats: true)
    }
  
  @objc func createEnemy() {
    guard let enemy = possibleEnemies.randomElement() else { return }
    
    let sprite = SKSpriteNode(imageNamed: enemy)
    sprite.name = enemy
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    addChild(sprite)
    enemyCounter += 1
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.angularDamping = 0
    
    gameTimer?.invalidate()
    
    gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
  }
  
  @objc func createPerk() {
    guard let perk = possiblePerks.randomElement() else { return }
    
    let sprite = SKSpriteNode(imageNamed: perk)
    sprite.name = perk
    sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
    addChild(sprite)
    sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
    sprite.physicsBody?.categoryBitMask = 1
    sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
    sprite.physicsBody?.angularVelocity = 5
    sprite.physicsBody?.linearDamping = 0
    sprite.physicsBody?.angularDamping = 0
    sprite.addGlow(radius: 30)
    
    perkTimer?.invalidate()
    
    perkTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 10.0...20.0), target: self, selector: #selector(createPerk), userInfo: nil, repeats: true)
  }
    
    override func update(_ currentTime: TimeInterval) {
      for node in children {
        if node.position.x < -300 {
          node.removeFromParent()
        }
      }
      if !isGameOver {
        score += 1
      }
    }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    for touch in touches {
      var location = touch.location(in: self)
      let touchedNode = self.nodes(at: location)
      for node in touchedNode {
        if node.name == "Player" {
          self.view?.isMultipleTouchEnabled = false

          if location.y < 100 {
            location.y = 100
          } else if location.y > 668 {
            location.y = 668
          }
          
          player.position = location
        
        }
      }
    }
  }
    
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    super.touchesEnded(touches, with: event)
    
    for touch in touches {
      let location = touch.location(in: self)
      let touchedNode = self.nodes(at: location)
      for node in touchedNode {
        if node.name == "Player" {
          player.position.y = node.position.y
          player.position.x = node.position.x
        }
      }
      guard let restartButton = restartButton else { return }
      if restartButton.contains(location) {
        restartGame()
      }
    }
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
  // Метод для рестарта игры
  func restartGame() {
    backgroundMusic.run(SKAction.stop())
    isGameOver = false
    removeAllChildren()
    gameTimer?.invalidate()
    time = 1.0
    round = 1
    gameTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    
    backgroundColor = .black
    starfield = SKEmitterNode(fileNamed: "starfield")!
    starfield.position = CGPoint(x: 1024, y: 384)
    starfield.advanceSimulationTime(10)
    addChild(starfield)
    starfield.zPosition = -1
    
    player = SKSpriteNode(imageNamed: "player")
    player.name = "Player"
    player.position = CGPoint(x: 100, y: 384)
    player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
    player.physicsBody?.contactTestBitMask = 1
    addChild(player)
        
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.position = CGPoint(x: 16, y: 16)
    scoreLabel.horizontalAlignmentMode = .left
    addChild(scoreLabel)
    
    roundChanged = SKLabelNode(fontNamed: "Chalkduster")
    roundChanged.text = "Round 1"
    roundChanged.position = CGPoint(x: 768, y: 684)
    roundChanged.horizontalAlignmentMode = .left
    addChild(roundChanged)
    
    score = 0
    physicsWorld.gravity = .zero
    physicsWorld.contactDelegate = self
    
    if let musicURL = Bundle.main.url(forResource: "background", withExtension: "m4a") {
      backgroundMusic = SKAudioNode(url: musicURL)
      addChild(backgroundMusic)
    } else {
      print("Error loading background music")
    }
  }
  // Эффект вспышки экрана при получении перка "Blast"
  func flashTheScreen(nTimes: Int) {
    let lightUpScreenAction = SKAction.run { self.backgroundColor = UIColor.gray }
      let waitAction = SKAction.wait(forDuration: 0.05)
      let dimScreenAction = SKAction.run {
        self.backgroundColor = .black
      }
      
      var flashActionSeq: [SKAction] = []
      for _ in 1 ... nTimes + 1 {
        flashActionSeq.append(contentsOf: [lightUpScreenAction, waitAction, dimScreenAction, waitAction])
      }
    self.run(SKAction.sequence(flashActionSeq))
  }
  // Метод для отслеживания столкновения игрока с разными предметами
  func playerCollided(with node: SKNode) {
    if node.name == "blast" {
      player.physicsBody?.isDynamic = false
      run(SKAction.playSoundFileNamed("thunder.caf", waitForCompletion: false))
      flashTheScreen(nTimes: 10)
      node.removeFromParent()
      for child in children {
        if child.name == "ball" || child.name == "hammer" || child.name == "tv" {
          child.removeFromParent()
        }
      }
    } else {
      let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()
        gameTimer?.invalidate()
        isGameOver = true

        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        run(SKAction.playSoundFileNamed("gameover.caf", waitForCompletion: true))

        restartButton = SKSpriteNode(texture: .none, size: CGSize(width: 300, height: 50))
        restartButton.position = CGPoint(x: 512, y: 324)
        restartButton.zPosition = 1
        addChild(restartButton)

        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart game"
        restartLabel.horizontalAlignmentMode = .center
        restartLabel.isHidden = false
        restartLabel.zPosition = 2

      restartButton.addChild(restartLabel)
    }
  }
}

// Функция для добавления эффекта свечения
extension SKNode {
  func addGlow(radius: Float = 30) {
    let view = SKView()
    let effectNode = SKEffectNode()
    let texture = view.texture(from: self)
    effectNode.shouldRasterize = true
    effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
    addChild(effectNode)
    effectNode.addChild(SKSpriteNode(texture: texture))
    
  }
}
