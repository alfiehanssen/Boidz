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
    private var simulation: Simulation<AgentNode>!
    private var scene: SKScene!
    
    // MARK: Lifecycle 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setupScene()
        self.setupSimulation()
    }

    // MARK: Setup
    
    private func setupScene()
    {
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
        self.scene.delegate = self
        
        view.presentScene(self.scene)
    }
    
    private func setupSimulation()
    {
        let agent1 = AgentNode(position: CGPoint(x: 0, y: 100), velocity: CGVector(dx: 1, dy: 2))
        let agent2 = AgentNode(position: CGPoint(x: 10, y: 102), velocity: CGVector(dx: 1, dy: 1))
        let agent3 = AgentNode(position: CGPoint(x: 20, y: 150), velocity: CGVector(dx: 0, dy: 2))
        
        self.scene.addChild(agent1)
        self.scene.addChild(agent2)
        self.scene.addChild(agent3)
        
        self.simulation = Simulation(agents: [agent1, agent2, agent3])
    }

    // MARK: SKSceneDelegate
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene)
    {
        self.simulation.update()
    }
}

