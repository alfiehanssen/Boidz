//
//  AgentSystem.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import Foundation
import CoreGraphics

// TODO: Keep agent array sorted, insert new agents into proper place. Otherwise we get something like On^2 time. [AH] 6/25/2016

class Simulation<T: Agent>
{
    private let boundaryAvoidance: CGFloat = 1
    private var bounds: CGRect
    private var agents: [T]
    
    init(bounds: CGRect, agents: [T])
    {
        self.bounds = bounds
        self.agents = agents
    }
    
    // MARK: Public API 
    
    func update()
    {
        assert(NSThread.isMainThread(), "For now, invoke \(#function) from the main thread.")

        let updatedAgents = self.agents.map { (agent) -> T in
            
            let neighbors = self.dynamicType.neighbors(agent: agent, agents: self.agents)
            
            let separation = self.dynamicType.separationVector(agent: agent, agents: neighbors)
            let alignment = self.dynamicType.alignmentVector(agent: agent, agents: neighbors)
            let cohesion = self.dynamicType.cohesionVector(agent: agent, agents: neighbors)
            let flocking = CGVector.add(vectors: separation, alignment, cohesion)
            
            let bounding = self.dynamicType.boundingVector(agent: agent, bounds: self.bounds)
            
            var velocity = CGVector.add(vectors: agent.velocity, flocking, bounding)
            velocity = CGVector.boundMagnitude(vector: velocity, min: agent.attributes.minSpeed, max: agent.attributes.maxSpeed)

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

    private static func separationVector(agent agent: T, agents: [T]) -> CGVector
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
            
            if distance < agent.attributes.maxSeparation
            {
                separation = CGVector.subtract(v1: separation, v2: displacement)
            }
        }
        
        return separation
    }
    
    private static func alignmentVector(agent agent: T, agents: [T]) -> CGVector
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
        alignment = CGVector.multiply(vector: alignment, scalar: agent.attributes.alignmentWeight)
        
        return alignment
    }
    
    private static func cohesionVector(agent agent: T, agents: [T]) -> CGVector
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
        cohesion = CGVector.multiply(vector: cohesion, scalar: agent.attributes.cohesionWeight)
        
        return cohesion
    }    

    private static func boundingVector(agent agent: T, bounds: CGRect) -> CGVector
    {
        // TODO: Inject this value? Make it stronger the further across the boundaries they are? [AH] 6/26/2016
        
        let boundaryAvoidance: CGFloat = 1
        var boundingVector = CGVector.zero
        
        if agent.position.x < bounds.origin.x
        {
            boundingVector.dx = boundaryAvoidance
        }
        
        if agent.position.x > bounds.origin.x + bounds.size.width
        {
            boundingVector.dx = -boundaryAvoidance
        }

        if agent.position.y < bounds.origin.y
        {
            boundingVector.dy = boundaryAvoidance
        }
        
        if agent.position.y > bounds.origin.y + bounds.size.height
        {
            boundingVector.dy = -boundaryAvoidance
        }

        return boundingVector
    }
}
