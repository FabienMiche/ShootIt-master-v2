//
//  GameViewController.swift
//  ShootIt
//
//  Created by etudiant on 08/04/2019.
//  Copyright © 2019 etudiant. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct pause {
    static var pauseValue:Bool = false
}


class GameViewController: UIViewController {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var gameScene: GameScene = GameScene()
    var slots = [WhackSlot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        let skView = self.view as! SKView
        pause.pauseValue = true
        skView.scene?.isPaused = true
        pauseButton.isHidden = true
        resumeButton.isHidden = false
        gameScene.chrono.invalidate()
    }
    
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        let skView = self.view as! SKView
        pause.pauseValue = false
        skView.scene?.isPaused = false
        pauseButton.isHidden = false
        resumeButton.isHidden = true
    }
    
}
