//
//  GameViewController.swift
//  breakout
//
//  Created by Kinpira on 2014/10/26.
//  Copyright (c) 2014年 Kinpira. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController,EscapeProtocol{
    
    var skView:SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as? SKView
        skView!.ignoresSiblingOrder = true
        startGame()
        
    }
    
    func startGame(){
        let scene = GameScene(size: skView!.bounds.size)
        scene.delegate_escape = self
        self.skView!.presentScene(scene)
    }
    func gameover(){
        let scene = GameOver(size: skView!.bounds.size)
        scene.delegate_escape = self
        self.skView!.presentScene(scene)
    }

    func escape(scene: SKScene) {
        
        if scene.isKindOfClass(GameOver) {
            startGame()
        } else if scene.isKindOfClass(GameScene) {
            gameover()
        }
    }

    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
