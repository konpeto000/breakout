//
//  GameViewController.swift
//  breakout
//
//  Created by Kinpira on 2014/10/26.
//  Copyright (c) 2014年 Kinpira. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController,EscapeProtocol{
    
    var skView: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = self.view as? SKView
        skView!.ignoresSiblingOrder = true
        startGame()
        
    }
    
    func startGame(){
        let scene = GameScene()
        scene.delegate_escape = self
        scene.size = self.skView!.bounds.size
        self.skView!.presentScene(scene)
    }
    func gameover(){
        let scene = GameOver()
        scene.delegate_escape = self
        scene.size = self.skView!.bounds.size
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

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        } else {
            return Int(UIInterfaceOrientationMask.All.toRaw())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
