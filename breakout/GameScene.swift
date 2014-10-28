//
//  GameScene.swift
//  breakout
//
//  Created by Kinpira on 2014/10/26.
//  Copyright (c) 2014年 Kinpira. All rights reserved.
//

import SpriteKit


//Score and life
var ballLife:UInt!
var score:UInt!

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    //dalegate
    var delegate_escape: EscapeProtocol?
    
    //Loop flag
    var loop:Bool = false,reboneflag:Bool = false,deadflag:Bool = false
    
    //String
    var showString:SKLabelNode!
    
    //score Magnification
    var score_mag:Int!
    
    //deadzone
    var deadzone : SKSpriteNode!
    
    //Block
    let block_row:Int = 10,block_col:Int = 10
    let block_width:CGFloat = 30,block_height:CGFloat = 20
    let margin:CGFloat = 2
    var block_x:CGFloat!,block_y:CGFloat!
    
    //Player Bar
    let p_width:CGFloat = 100,p_height:CGFloat = 20
    var player:SKSpriteNode!
    var x:CGFloat!,y:CGFloat!
    
    //Ball
    let b_width:CGFloat = 8,b_height:CGFloat = 8
    var ball:SKSpriteNode!
    var bx:CGFloat!,by:CGFloat!
    
    //CollistonMask
    let blockCategory: UInt32 = 1 << 0
    let ballCategory:  UInt32 = 1 << 1
    let wallCategory:  UInt32 = 1 << 2
    let playerCategory:UInt32 = 1 << 3
    let deadCategory:  UInt32 = 1 << 4
    
    func initialize(){
        
        //backbroundcolor
        self.backgroundColor = UIColor.grayColor()
        
        //selfphysics
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect:self.frame)
        self.physicsWorld.gravity = CGVectorMake( 0.0, 0.0 )
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.collisionBitMask = wallCategory
        
        //loop flag
        loop = false
        reboneflag = false
        deadflag = false
        
        //score and life
        score = 0
        score_mag = 0
        ballLife = 3
        showString = SKLabelNode()
        showString.text = ("Life:\(ballLife)  Score:\(score)")
        showString.position = CGPointMake(self.size.width/2, self.size.height-showString.frame.height-20)
        self.addChild(showString)
        
        //deadzone
        deadzone = SKSpriteNode()
        deadzone.position = CGPointMake(self.size.width/2,50)
        deadzone.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width, 20))
        deadzone.physicsBody?.dynamic = false
        deadzone.physicsBody?.collisionBitMask = deadCategory
        deadzone.physicsBody?.contactTestBitMask = ballCategory
        self.addChild(deadzone)
        
        //block
        for (var i:Int = 1;i <= self.block_row;i++){
            for(var j:Int = 1;j <= self.block_col;j++){
                let block = SKSpriteNode(color:UIColor.blueColor().colorWithAlphaComponent(1-CGFloat(j)/CGFloat((block_row+1)*(block_col+1))*10),size:CGSizeMake(block_width,block_height))
                let block_position = CGPointMake(CGFloat(i)*(self.size.width/CGFloat(block_row+1)), self.size.height-CGFloat(j)*(block_height+margin)-50)
                block.name = "block"
                block.position = block_position
                block.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(block_width, block_height))
                block.physicsBody?.dynamic = false
                block.physicsBody?.collisionBitMask = blockCategory
                block.physicsBody?.contactTestBitMask = ballCategory
                self.addChild(block)
            }
        }
        
        //player
        x = CGRectGetMidX(self.frame);y = CGRectGetMinY(self.frame) + 100
        player = SKSpriteNode(color:UIColor.whiteColor(),size:CGSizeMake(p_width,p_height))
        player.position = CGPointMake(x,y)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(p_width, p_height))
        player.physicsBody?.dynamic = false
        player.physicsBody?.collisionBitMask = playerCategory
        
        //ball
        bx = x;by = y + 100
        ball = SKSpriteNode(color:UIColor.yellowColor(),size:CGSizeMake(b_width, b_height))
        ball.position = CGPointMake(bx, by)
        ball.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(b_width, b_height))
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.collisionBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = blockCategory|deadCategory|playerCategory
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.friction = 0
        ball.physicsBody?.linearDamping = 0
        self.addChild(self.player)
        self.addChild(self.ball)
    }
    

    override func didMoveToView(view: SKView) {

        initialize()
    
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if(!loop){
            movingBall()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {

        if(loop){
            for touch in touches{
                let location = touch.locationInNode(self)
                player.position.x = location.x
            }
        }
    }
    class func lifeAndScore() -> (life:UInt,score:UInt){
        return (life:ballLife,score:score)
    }
    
    func movingBall(){
        loop = true
        var rnd = CGFloat(arc4random()%30)
        let ballVel = CGVector(((arc4random()%2 == 0) ? -200-rnd:200+rnd),200)
        ball.physicsBody?.velocity = ballVel
    }
    
    func accelerate() {
        ball.physicsBody?.velocity.dx *= 1.01
        ball.physicsBody?.velocity.dy *= 1.01
    }
    func rebone(){
        reboneflag = false
        ballLife = ballLife - 1
        loop = false
        ball.physicsBody?.velocity = CGVector(0,0)
        player.position = CGPointMake(x,y)
        ball.position = CGPointMake(bx, by)
    }
    func restart(){
        delegate_escape?.escape(self)
    }
    
    //Colision Checking
    func didBeginContact(contact: SKPhysicsContact) {
        var first,second : SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            first = contact.bodyA
            second = contact.bodyB
        }else{
            first = contact.bodyB
            second = contact.bodyA
        }
        if(first.collisionBitMask == ballCategory){
            switch second.collisionBitMask{
            case blockCategory:
                accelerate()
                score = score + 100 + 100*score_mag
                score_mag = score_mag + 1
                second.node?.removeFromParent()
            case deadCategory :
                if(ballLife > 1){
                    reboneflag = true
                }else{
                    deadflag = true
                }
            case playerCategory:
                score_mag = 0
            default:
                break
            }
            
        }
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        showString.text = ("Life:\(ballLife)  Score:\(score)")
        if(reboneflag){
            rebone()
        }
        if(deadflag||self.childNodeWithName("block") == nil){
            restart()
        }
    }
}
