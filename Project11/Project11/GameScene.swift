//
//  GameScene.swift
//  Project11
//
//  Created by Айсен Еремеев on 14.12.2022.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
  var scoreLabel: SKLabelNode!
  var ballsLabel: SKLabelNode!
  var startNewGame: SKLabelNode!
  var newRoundCountDown: SKLabelNode!
  
  var counter = 5 {
    didSet {
      self.newRoundCountDown.text = "Starting new round in: \(self.counter)"
      if counter == 0 {
//        newRoundCountDown.isHidden = true
        for child in children {
          if child.name == "newRoundCountDown" {
            print("Got round label")
            child.removeFromParent()
          }
        }
        self.counter = 5
        score = 0
        ballsLeft = 5
      }
    }
  }
  
  var score = 0 {
    didSet {
      scoreLabel.text = "Score: \(score)"
    }
  }
  
  var ballsLeft = 5 {
    didSet {
      ballsLabel.text = "Balls left: \(ballsLeft)"
    }
  }
  
  var editLabel: SKLabelNode!
  
  var editingMode: Bool = false {
    didSet {
      if editingMode {
        editLabel.text = "Done"
      } else {
        editLabel.text = "Edit"
      }
    }
  }
    
    override func didMove(to view: SKView) {
      let background = SKSpriteNode(imageNamed: "background")
      background.position = CGPoint(x: 512, y: 384)
      background.blendMode = .replace
      background.zPosition = -1
      addChild(background)
      
      scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
      scoreLabel.text = "Score: 0"
      scoreLabel.horizontalAlignmentMode = .right
      scoreLabel.position = CGPoint(x: 980, y: 700)
      addChild(scoreLabel)
      
      startNewGame = SKLabelNode(fontNamed: "Chalkduster")
      startNewGame.text = "Restart"
      startNewGame.horizontalAlignmentMode = .right
      startNewGame.position = CGPoint(x: 700, y: 700)
      addChild(startNewGame)
      
      newRoundCountDown = SKLabelNode(fontNamed: "Chalkduster")
      newRoundCountDown.text = "Starting new round in: 5"
      newRoundCountDown.horizontalAlignmentMode = .center
      newRoundCountDown.position = CGPoint(x: 512, y: 384)
      newRoundCountDown.isHidden = true
      addChild(newRoundCountDown)
      
      
      ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
      ballsLabel.text = "Balls left: 5"
      ballsLabel.horizontalAlignmentMode = .right
      ballsLabel.position = CGPoint(x: 450, y: 700)
      addChild(ballsLabel)
      
      editLabel = SKLabelNode(fontNamed: "Chalkduster")
      editLabel.text = "Edit"
      editLabel.position = CGPoint(x: 80, y: 700)
      addChild(editLabel)
      
      physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
      physicsWorld.contactDelegate = self
      
      makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
      makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
      makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
      makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
      
      makeBouncer(at: CGPoint(x: 0, y: 0))
      makeBouncer(at: CGPoint(x: 256, y: 0))
      makeBouncer(at: CGPoint(x: 512, y: 0))
      makeBouncer(at: CGPoint(x: 768, y: 0))
      makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let objects = nodes(at: location)
    let balls = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    
    if objects.contains(editLabel) {
      editingMode.toggle()
    }
    if objects.contains(startNewGame) {
      startNewRound()
    }
    if editingMode {
        // create box
        let size = CGSize(width: Int.random(in: 56...128), height: 16)
        let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
      }
    if ballsLeft > 0 {
        let ball = SKSpriteNode(imageNamed: "\(balls[Int.random(in: 0...6)])")
        ballsLeft -= 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        ball.position = CGPoint(x: location.x, y: 650)
        ball.name = "ball"
        addChild(ball)
      }
  }
  
  func makeBouncer(at position: CGPoint) {
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = position
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
    bouncer.physicsBody?.isDynamic = false
    addChild(bouncer)
  }
  
  func makeSlot(at position: CGPoint, isGood: Bool) {
    var slotBase: SKSpriteNode
    var slotGlow: SKSpriteNode
    
    if isGood {
      slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
      slotBase.name = "good"
    } else {
      slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
      slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
      slotBase.name = "bad"
    }
    
    slotBase.position = position
    slotGlow.position = position
    
    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false
    
    addChild(slotBase)
    addChild(slotGlow)
    
    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForever = SKAction.repeatForever(spin)
    slotGlow.run(spinForever)
  }
  
  func collision(between ball: SKNode, object: SKNode) {
    if object.name == "good" {
      destroy(ball: ball)
      score += 1
      ballsLeft += 1
    } else if object.name == "bad" {
      destroy(ball: ball)
      score -= 1
    }
  }
  
  func destroy(ball: SKNode) {
    if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
      fireParticles.position = ball.position
      addChild(fireParticles)
    }
    ball.removeFromParent()
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    guard let nodeA = contact.bodyA.node else { return }
    guard let nodeB = contact.bodyB.node else { return }
    
    if contact.bodyA.node?.name == "ball" {
      collision(between: nodeA, object: nodeB)
    } else if contact.bodyB.node?.name == "ball" {
      collision(between: nodeB, object: nodeA)
    }
  }
  
  func startNewRound() {
    ballsLeft = 0
    newRoundCountDown.isHidden = false
    // Объявляем переменную для ожидания 2 секунд
    let wait2Seconds = SKAction.wait(forDuration: 2)
    // Инкрементируем счетчик
    let incrementCounter = SKAction.run { [weak self] in
      for _ in 0...4 {
        self?.counter -= 1
      }
    }
    // Ждем 2 секунды и запускаем счетчик
    let sequence = SKAction.sequence([wait2Seconds, incrementCounter])
    
    let repeatForever = SKAction.repeatForever(sequence)
    self.run(repeatForever)
  }
}
