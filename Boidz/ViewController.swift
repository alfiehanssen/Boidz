//
//  ViewController.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, SKSceneDelegate
{
    private let simulation = Simulation()
    private var scene: SKScene!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        guard let view = self.view as? SKView else
        {
            assertionFailure("Unable to case self.view to SKView.")
            
            return
        }
        
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
        self.scene = SKScene(size: self.view.bounds.size)
        self.scene.backgroundColor = UIColor.whiteColor()
        self.scene.scaleMode = SKSceneScaleMode.Fill
        
        view.presentScene(self.scene)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: SKSceneDelegate
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene)
    {
        self.simulation.update()
    }
}

