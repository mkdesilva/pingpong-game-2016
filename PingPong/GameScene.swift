//
//  GameScene.swift
//  PingPong
//
//  Created by Min on 7/6/16.
//  Copyright (c) 2016 mihinduDeSilva. All rights reserved.
//

import SpriteKit

struct PhysicsBodies {
    static let Player : UInt32 = 0x1 << 1
    static let Wall : UInt32 = 0x1 << 2
    static let Ball : UInt32 = 0x1 << 3
   }

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode ()
    var ball = SKShapeNode(circleOfRadius: 10)
    var enemy = SKSpriteNode()
    var yVelocity: CGFloat = -5
    var xVelocity: CGFloat = 1
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        let xMiddleOfScreen = self.frame.width/2
        let yMiddleOfScreen = self.frame.height/2
        let posMiddleOfScreen = CGPointMake(xMiddleOfScreen,yMiddleOfScreen)
        
        /* Setup your scene here */
        backgroundColor = UIColor.blackColor()
        
        let whiteDivide = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.frame.width, 5))
        whiteDivide.position = posMiddleOfScreen
        
        player = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.frame.width/10, 5))
        player.position = CGPointMake(self.frame.width/2,20)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = PhysicsBodies.Player
        player.physicsBody?.collisionBitMask = PhysicsBodies.Ball
        player.physicsBody?.contactTestBitMask = PhysicsBodies.Ball
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = false
        
        player.physicsBody?.friction = 0.0 //stops ball from slowing down when it hits you
        
        enemy.color = UIColor.whiteColor()
        enemy.size = CGSizeMake(self.frame.width, 40)
        enemy.position = CGPointMake(xMiddleOfScreen, self.frame.height)
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.categoryBitMask = PhysicsBodies.Wall
        enemy.physicsBody?.collisionBitMask = PhysicsBodies.Ball
        enemy.physicsBody?.contactTestBitMask = PhysicsBodies.Ball
        enemy.physicsBody?.friction = 0
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = false
        
        ball.fillColor = UIColor.whiteColor()
        ball.position = posMiddleOfScreen
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.categoryBitMask = PhysicsBodies.Ball
        ball.physicsBody?.collisionBitMask = PhysicsBodies.Player | PhysicsBodies.Wall
        ball.physicsBody?.contactTestBitMask = PhysicsBodies.Player | PhysicsBodies.Wall
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        
        self.addChild(ball)
        self.addChild(player)
        self.addChild(enemy)
        self.addChild(whiteDivide)
    }
    
    func getBallPos() -> CGPoint {
        return CGPointMake(ball.position.x + xVelocity, ball.position.y+yVelocity)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let objectA = contact.bodyA
        let objectB = contact.bodyB
        
        if objectA.categoryBitMask == PhysicsBodies.Ball && objectB.categoryBitMask == PhysicsBodies.Player || objectA.categoryBitMask == PhysicsBodies.Player && objectB.categoryBitMask == PhysicsBodies.Ball {
            yVelocity = yVelocity * -1
            xVelocity = xVelocity * -1
        }
        
        if objectA.categoryBitMask == PhysicsBodies.Ball && objectB.categoryBitMask == PhysicsBodies.Wall || objectA.categoryBitMask == PhysicsBodies.Wall && objectB.categoryBitMask == PhysicsBodies.Ball {
            yVelocity = yVelocity * -1
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        let previousLocation = touch!.previousLocationInNode(self)
        
        var paddleX = player.position.x + (touchLocation.x - previousLocation.x)
        // 5
        paddleX = max(paddleX, player.size.width/2)
        paddleX = min(paddleX, size.width - player.size.width/2)
        // 6
        player.position = CGPoint(x: paddleX, y: player.position.y)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        ball.position = getBallPos()
        
    }
}
