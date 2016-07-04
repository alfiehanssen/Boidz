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
    private static let NumberOfAgents = 10
    
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
            assertionFailure("Unable to cast self.view to SKView.")
            
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
        let attributes = BirdAttributes()
        
        var agents = [AgentNode]()
        
        for i in 0...self.dynamicType.NumberOfAgents
        {
            let position = CGPoint(x: i, y: 10)
            let velocity = CGVector(dx: i, dy: 3)

            let agent = AgentNode(position: position, velocity: velocity, attributes: attributes)
            self.scene.addChild(agent)
            agents.append(agent)
        }
        
        let bounds = self.view.bounds
        self.simulation = Simulation(bounds: bounds, agents: agents)
    }

    // MARK: SKSceneDelegate
    
    func update(currentTime: NSTimeInterval, forScene scene: SKScene)
    {
        self.simulation.update()
    }
}

