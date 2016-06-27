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
        let position = CGPoint(x: 0, y: 100)
        let velocity = CGVector(dx: 1, dy: 2)
        let attributes = BirdAttributes()
        
        let agent1 = AgentNode(position: position, velocity: velocity, attributes: attributes)
        let agent2 = AgentNode(position: position, velocity: velocity, attributes: attributes)
        let agent3 = AgentNode(position: position, velocity: velocity, attributes: attributes)
        
        self.scene.addChild(agent1)
        self.scene.addChild(agent2)
        self.scene.addChild(agent3)
        
        let bounds = self.view.bounds
        let agents = [agent1, agent2, agent3]
        self.simulation = Simulation(bounds: bounds, agents: agents)
    }

    // MARK: SKSceneDelegate
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene)
    {
        self.simulation.update()
    }
}

