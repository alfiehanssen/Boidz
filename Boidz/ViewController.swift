//
//  ViewController.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

