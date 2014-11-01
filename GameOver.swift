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

        let board = SKNode()
        self.backgroundColor = UIColor.grayColor()
        let gameover = SKLabelNode()
        gameover.text = "Gameover"
        gameover.fontSize = 50
        gameover.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200)
    
        board.addChild(gameover)
        
        var values = GameScene.lifeAndScore()

        let scoreAndlife = SKLabelNode()
        scoreAndlife.text = "Score :\(values.score)  Life:\(values.life)"
        scoreAndlife.fontSize = 20
        scoreAndlife.position.x = gameover.position.x
        scoreAndlife.position.y = gameover.position.y-40
        board.addChild(scoreAndlife)
        
        let finalScore = SKLabelNode()
        finalScore.text = "FinalScore = Score * Life "
        finalScore.position.x = scoreAndlife.position.x
        finalScore.position.y = scoreAndlife.position.y-40
        board.addChild(finalScore)
        
        let score = SKLabelNode()
        score.text = " \(values.score * values.life)"
        score.position.x = finalScore.position.x
        score.position.y = finalScore.position.y-100
        board.addChild(score)
        
        let ud = NSUserDefaults()
        let beforeScore = ud.integerForKey("highscore")
        if(beforeScore < Int(values.score * values.life)){
            ud.setInteger(Int(values.score * values.life),forKey: "highscore")
        }
        let highscoreLabel = SKLabelNode()
        let highscore = ud.integerForKey("highscore")
        highscoreLabel.text = "HighScore:\(highscore)"
        highscoreLabel.position.x = score.position.x
        highscoreLabel.position.y = score.position.y - 100
        board.addChild(highscoreLabel)
        
        let retry = SKLabelNode()
        retry.text = "Tap to retry"
        retry.position.x = score.position.x
        retry.position.y = score.position.y-200
        board.addChild(retry)

        self.addChild(board)
        
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        delegate_escape?.escape(self)
        
    }
}