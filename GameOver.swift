//
//  GameOver.swift
//  breakout
//
//  Created by Kinpira on 2014/10/28.
//  Copyright (c) 2014年 Kinpira. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    var delegate_escape: EscapeProtocol?
    
    override func didMoveToView(view: SKView) {

        let borad = SKNode()
        self.backgroundColor = UIColor.grayColor()
        let gameover = SKLabelNode()
        gameover.text = "Gameover"
        gameover.fontSize = 50
        gameover.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)
    
        borad.addChild(gameover)
        
        var value = GameScene.lifeAndScore()

        let scoreAndlife = SKLabelNode()
        scoreAndlife.text = "Score :\(value.score)  Life:\(value.life)"
        scoreAndlife.fontSize = 20
        scoreAndlife.position.x = gameover.position.x
        scoreAndlife.position.y = gameover.position.y-40
        borad.addChild(scoreAndlife)
        
        let finalScore = SKLabelNode()
        finalScore.text = "FinalScore = Score * Life "
        finalScore.position.x = scoreAndlife.position.x
        finalScore.position.y = scoreAndlife.position.y-40
        borad.addChild(finalScore)
        
        let score = SKLabelNode()
        score.text = " \(value.score * value.life)"
        score.position.x = finalScore.position.x
        score.position.y = finalScore.position.y-140
        borad.addChild(score)
        
        let retry = SKLabelNode()
        retry.text = "Tap to retry"
        retry.position.x = score.position.x
        retry.position.y = score.position.y-140
        borad.addChild(retry)

        self.addChild(borad)
        
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        delegate_escape?.escape(self)
        
    }
}