//
//  AgentSystem.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import Foundation
import CoreGraphics

func ==(lhs: Agent, rhs: Agent) -> Bool
{
    return lhs.identifier == rhs.identifier
}

struct Agent: Equatable
{
    let identifier = NSProcessInfo.processInfo().globallyUniqueString
    
    var position: CGPoint
    var velocity: CGVector
    
    init(position: CGPoint = .zero, velocity: CGVector = .zero)
    {
        self.position = position
        self.velocity = velocity
    }
}

struct SimParameters
{
    static let AlignmentWeight: CGFloat = 0.125
    static let CohesionWeight: CGFloat = 0.01
    static let MinSeparation: CGFloat = 10
}

class Simulation
{
    // TODO: Keep agent array sorted, insert new agents into proper place. [AH] 6/25/2016
    // Otherwise we get something like On^2 time.
    
    private(set) var agents: [Agent] = []
    
    func update()
    {
        var updatedAgents: [Agent] = []

        for agent in self.agents
        {
            let neighbors = self.dynamicType.neighbors(agent: agent, agents: self.agents)
            
            let flockingVector = self.dynamicType.flockingVector(agent: agent, agents: neighbors)
            if flockingVector == .zero
            {
                // TODO: Add the wander vector as a fallback. [AH] 6/26/2016
            }
            
            let velocity = CGVector.add(vectors: agent.velocity, flockingVector)
            let position = CGPoint.displace(point: agent.position, vector: velocity)
            
            var updatedAgent = agent
            updatedAgent.position = position
            updatedAgent.velocity = velocity
            updatedAgents.append(updatedAgent)
        }
        
        self.agents = updatedAgents
    }
    
    private static func neighbors(agent agent: Agent, agents: [Agent]) -> [Agent]
    {
        return agents // TODO: Add the notion of neighborhood. [AH] 6/26/2016
    }

    private static func flockingVector(agent agent: Agent, agents: [Agent]) -> CGVector
    {
        let separation = self.separationVector(agent: agent, agents: agents)
        let alignment = self.alignmentVector(agent: agent, agents: agents)
        let cohesion = self.cohesionVector(agent: agent, agents: agents)

        return CGVector.add(vectors: separation, alignment, cohesion)
    }

    private static func separationVector(agent agent: Agent, agents: [Agent]) -> CGVector
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
            
            if distance < SimParameters.MinSeparation
            {
                separation = CGVector.subtract(v1: separation, v2: displacement)
            }
        }
        
        return separation
    }
    
    private static func alignmentVector(agent agent: Agent, agents: [Agent]) -> CGVector
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
        alignment = CGVector.multiply(vector: alignment, scalar: SimParameters.AlignmentWeight)
        
        return alignment
    }
    
    private static func cohesionVector(agent agent: Agent, agents: [Agent]) -> CGVector
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
        cohesion = CGVector.multiply(vector: cohesion, scalar: SimParameters.CohesionWeight)
        
        return cohesion
    }
}
