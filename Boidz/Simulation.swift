//
//  AgentSystem.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import Foundation
import CoreGraphics

struct SimulationParameters
{
    var alignmentWeight: CGFloat = 0.125
    {
        didSet
        {
            assert(self.alignmentWeight >= 0 && self.alignmentWeight <= 1, "Alignment must be a value between 0 and 1.")
        }
    }
    
    var cohesionWeight: CGFloat = 0.01
    {
        didSet
        {
            assert(self.cohesionWeight >= 0 && self.cohesionWeight <= 0, "Cohesion must be a value between 0 and 1.")
        }
    }

    var maxSeparation: CGFloat = 20
    
    var minSpeed: CGFloat = 1
    var maxSpeed: CGFloat = 4
    
    var bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
}

class Simulation<T: Agent>
{
    // TODO: Keep agent array sorted, insert new agents into proper place. [AH] 6/25/2016
    // Otherwise we get something like On^2 time.
    
    private let parameters: SimulationParameters
    private var agents: [T] = []
    
    convenience init(agents: [T])
    {
        self.init(agents: agents, parameters: SimulationParameters())
    }
    
    init(agents: [T], parameters: SimulationParameters)
    {
        self.agents = agents
        self.parameters = parameters
    }
    
    // MARK: Public API 
    
    func update()
    {
        assert(NSThread.isMainThread(), "For now, invoke \(#function) from the main thread.")

        let updatedAgents = self.agents.map { (agent) -> T in
            
            let neighbors = self.dynamicType.neighbors(agent: agent, agents: self.agents)
            
            let separation = self.dynamicType.separationVector(agent: agent, agents: neighbors, target: self.parameters.maxSeparation)
            let alignment = self.dynamicType.alignmentVector(agent: agent, agents: neighbors, weight: self.parameters.alignmentWeight)
            let cohesion = self.dynamicType.cohesionVector(agent: agent, agents: neighbors, weight: self.parameters.cohesionWeight)
            let flocking = CGVector.add(vectors: separation, alignment, cohesion)
            
            let bounding = self.dynamicType.boundingVector(agent: agent, bounds: self.parameters.bounds)
            
            var velocity = CGVector.add(vectors: agent.velocity, flocking, bounding)
            velocity = CGVector.boundMagnitude(vector: velocity, min: self.parameters.minSpeed, max: self.parameters.maxSpeed)

            let position = CGPoint.displace(point: agent.position, vector: velocity)
            
            var updatedAgent = agent
            updatedAgent.position = position
            updatedAgent.velocity = velocity
            
            return updatedAgent
        }
        
        self.agents = updatedAgents
    }
    
    // MARK: Private API
    
    private static func neighbors(agent agent: T, agents: [T]) -> [T]
    {
        return agents // TODO: Add the notion of neighborhood. [AH] 6/26/2016
    }

    private static func separationVector(agent agent: T, agents: [T], target: CGFloat) -> CGVector
    {
        var separation = CGVector.zero
        
        for currentAgent in agents
        {
            if agent == currentAgent
            {
                continue
            }
            
            let displacement = CGPoint.displacementVector(from: agent.position, to: currentAgent.position)
            let distance = CGVector.magnitude(vector: displacement)
            
            if distance < target
            {
                separation = CGVector.subtract(v1: separation, v2: displacement)
            }
        }
        
        return separation
    }
    
    private static func alignmentVector(agent agent: T, agents: [T], weight: CGFloat) -> CGVector
    {
        var alignment = CGVector.zero
        var scalar = agents.count

        for currentAgent in agents
        {
            if agent == currentAgent
            {
                scalar -= 1

                continue
            }

            alignment = CGVector.add(vectors: alignment, currentAgent.velocity)
        }
        
        alignment = CGVector.divide(vector: alignment, scalar: CGFloat(scalar))
        alignment = CGVector.subtract(v1: alignment, v2: agent.velocity)
        alignment = CGVector.multiply(vector: alignment, scalar: weight)
        
        return alignment
    }
    
    private static func cohesionVector(agent agent: T, agents: [T], weight: CGFloat) -> CGVector
    {
        var center = CGPoint.zero
        var scalar = agents.count
        
        for currentAgent in agents
        {
            if agent == currentAgent
            {
                scalar -= 1
                
                continue
            }

            center = CGPoint.add(points: center, currentAgent.position)
        }
        
        let target = CGPoint.divide(point: center, scalar: CGFloat(scalar))
        
        var cohesion = CGPoint.displacementVector(from: agent.position, to: target)
        cohesion = CGVector.multiply(vector: cohesion, scalar: weight)
        
        return cohesion
    }    

    private static func boundingVector(agent agent: T, bounds: CGRect) -> CGVector
    {
        // TODO: Inject this value. [AH] 6/26/2016
        // TODO: Make it stronger the further across the boundaries they are. [AH] 6/26/2016
        
        let repellingScalar: CGFloat = 1
        
        var boundingVector = CGVector.zero
        
        if agent.position.x < bounds.origin.x
        {
            boundingVector.dx = repellingScalar
        }
        
        if agent.position.x > bounds.origin.x + bounds.size.width
        {
            boundingVector.dx = -repellingScalar
        }

        if agent.position.y < bounds.origin.y
        {
            boundingVector.dy = repellingScalar
        }
        
        if agent.position.y > bounds.origin.y + bounds.size.height
        {
            boundingVector.dy = -repellingScalar
        }

        return boundingVector
    }
}
