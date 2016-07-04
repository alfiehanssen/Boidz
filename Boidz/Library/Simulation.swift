//
//  AgentSystem.swift
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

import Foundation
import CoreGraphics

// TODO: Add documentation to each element in this file. [AH] 7/4/2016
// TODO: Keep agent array sorted, insert new agents into proper place. Otherwise we get something like On^2 time. [AH] 6/25/2016

class Simulation<T: Agent>
{
    /// An unsigned scalar value used for the boundary vector dx/dy values shuold a bounding force be required.
    private let boundaryAvoidance: CGFloat = 10
    
    /// The physical bounds within which the simulation is conducted.
    private var bounds: CGRect
    
    /// The set of agents participating in the simulation.
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
            
            var velocity: CGVector
            if neighbors.count == 0
            {
                velocity = self.velocityVector(agent: agent)
            }
            else
            {
                velocity = self.velocityVector(agent: agent, neighbors: neighbors)
            }
            
            let position = CGPoint.displace(point: agent.position, vector: velocity)
            
            var updatedAgent = agent
            updatedAgent.position = position
            updatedAgent.previousVelocity = updatedAgent.velocity
            updatedAgent.velocity = velocity
            
            return updatedAgent
        }
        
        self.agents = updatedAgents
    }
    
    // MARK: Private API
    
    /**
     Given a set of agents and a unique member of that group, calculates the subset of agents within a certain proximity of this member.
     
     - parameter agent: The agent whose neighbors will be identified.
     - parameter neighbors: The set of agents from which neighbors will be identified.

     - returns: An array of neighboring agents.
     */
    private static func neighbors(agent agent: T, agents: [T]) -> [T]
    {
        // TODO: Calculate neighbors using distance and field of view instead of just distance. [AH] 7/4/2016

        var neighbors = [T]()
        
        for neighbor in agents
        {
            let displacement = CGPoint.displacementVector(from: agent.position, to: neighbor.position)
            let distance = CGVector.magnitude(vector: displacement)
            
            if distance < agent.attributes.neighborhoodRadius
            {
                neighbors.append(neighbor)
            }
        }
        
        return neighbors
    }

    /**
     Calculates the velocity vector for an individual agent without respect to neighbors. We compute the wander and bounding vectors. We add those together. And then clamp the resulting vector's magnitude by a min and max value.
     
     - parameter agent: The agent whose velocity should be calculated.
     
     - returns: The vector representing the new velocity (steering force) for the agent.
     */
    private func velocityVector(agent agent: T) -> CGVector
    {
        let wander = self.dynamicType.wanderVector(agent: agent)
        let bounding = self.dynamicType.boundingVector(agent: agent, bounds: self.bounds, boundaryAvoidance: self.boundaryAvoidance)
        
        var velocity = CGVector.add(vectors: agent.velocity, wander, bounding)
        velocity = CGVector.boundMagnitude(vector: velocity, min: agent.attributes.minSpeed, max: agent.attributes.maxSpeed)
        
        return velocity
    }

    /**
     Calculates the velocity vector for an agent with respect to it's neighbors. We first determine the separation, alighment, cohesion, and bounding vectors. We add those together. And then clamp the resulting vector's magnitude by a min and max value.
     
     - parameter agent: The agent whose velocity vector should be calculated.
     - parameter neighbors: The neighboring agents to take into account when performing this calculation.
     
     - returns: The vector representing the new velocity (steering force) for the agent.
     */
    private func velocityVector(agent agent: T, neighbors: [T]) -> CGVector
    {
        let separation = self.dynamicType.separationVector(agent: agent, agents: neighbors)
        let alignment = self.dynamicType.alignmentVector(agent: agent, agents: neighbors)
        let cohesion = self.dynamicType.cohesionVector(agent: agent, agents: neighbors)
        let bounding = self.dynamicType.boundingVector(agent: agent, bounds: self.bounds, boundaryAvoidance: self.boundaryAvoidance)
        
        var velocity = CGVector.add(vectors: agent.velocity, separation, alignment, cohesion, bounding)
        velocity = CGVector.boundMagnitude(vector: velocity, min: agent.attributes.minSpeed, max: agent.attributes.maxSpeed)
        
        return velocity
    }

    /**
     Calculates the wander steering vector for an agent.
     
     - parameter agent: The agent whose wander vector should be calculated.
     
     - returns: The vector representing the wander steering force for the agent.
     */
    private static func wanderVector(agent agent: T) -> CGVector
    {
        var wander = CGVector.zero

        // TODO: Calculate the wander force. [AH] 7/4/2016
        
        return wander
    }
    
//- (CGPoint)wanderingForce
//{
//    CGPoint n = CGPointMake( (float)random() / RAND_MAX, (float)random() / RAND_MAX );
//    n = ccpSub(n, ccp(.5, .5));
//    n = ccpNormalize(n);
//
//    CGPoint r_noise = ccpMult(n, ((AnimalSpecies *)self.species).k_noise);
//
//    CGPoint force = ccpAdd(self.previousWander, r_noise);
//    force = ccpMult( ccpNormalize(force), ((AnimalSpecies *)self.species).k_wander);
//    force = ccpAdd(self.velocity, force);
//    
//    return force;
//}

    /**
     Calculates the separation steering vector for an agent with respect to it's neighbors.
     
     - parameter agent: The agent whose separation vector should be calculated.
     - parameter neighbors: The neighboring agents to take into account when performing this calculation.
     
     - returns: The vector representing the separation steering force for the agent.
     */
    private static func separationVector(agent agent: T, agents: [T]) -> CGVector
    {
        var separation = CGVector.zero
        
        for currentAgent in agents
        {
            if agent == currentAgent
            {
                continue
            }
            
            var displacement = CGPoint.displacementVector(from: agent.position, to: currentAgent.position)
            let distance = CGVector.magnitude(vector: displacement)
            
            if distance < agent.attributes.minSeparation
            {
                displacement = CGVector.normalize(vector: displacement)
                displacement = CGVector.multiply(vector: displacement, scalar: agent.attributes.separationWeight)
                separation = CGVector.subtract(v1: separation, v2: displacement)
            }
        }
        
        return separation
    }
    
    /**
     Calculates the alignment steering vector for an agent with respect to it's neighbors.
     
     - parameter agent: The agent whose alignment vector should be calculated.
     - parameter neighbors: The neighboring agents to take into account when performing this calculation.
     
     - returns: The vector representing the alignment steering force for the agent.
     */
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
        
        if scalar != 0 // Avoid divide by 0 attempts
        {
            alignment = CGVector.divide(vector: alignment, scalar: CGFloat(scalar))
        }
        
        alignment = CGVector.subtract(v1: alignment, v2: agent.velocity)
        alignment = CGVector.normalize(vector: alignment)
        alignment = CGVector.multiply(vector: alignment, scalar: agent.attributes.alignmentWeight)
        
        return alignment
    }
    
    /**
     Calculates the cohesion steering vector for an agent with respect to it's neighbors.
     
     - parameter agent: The agent whose sohesion vector should be calculated.
     - parameter neighbors: The neighboring agents to take into account when performing this calculation.
     
     - returns: The vector representing the sohesion steering force for the agent.
     */
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
        
        var target = center
        if scalar != 0 // Avoid divide by 0 attempts
        {
            target = CGPoint.divide(point: target, scalar: CGFloat(scalar))
        }
        
        var cohesion = CGPoint.displacementVector(from: agent.position, to: target)
        cohesion = CGVector.normalize(vector: cohesion)
        cohesion = CGVector.multiply(vector: cohesion, scalar: agent.attributes.cohesionWeight)
        
        return cohesion
    }    

    // TODO: Use obstacle avoidance vector instead? [AH] 7/4/2016
    
    /**
     Calculates the bounding steering vector for an agent with respect to the bounds of its environment. This force causes the agent to direct itself away from the environment's boundaries when it encounters them.
     
     - parameter agent: The agent whose separation vector should be calculated.
     - parameter bounds: The bounds of the agent's environment.
     - parameter boundaryAvoidance: An unsigned scalar value used as the bounding force's components.
     
     - returns: The vector representing the bounding steering force for the agent.
     */
    private static func boundingVector(agent agent: T, bounds: CGRect, boundaryAvoidance: CGFloat) -> CGVector
    {
        var boundingVector = CGVector.zero
        
        if agent.position.x < bounds.origin.x
        {
            boundingVector.dx = boundaryAvoidance
        }
        else if agent.position.x > bounds.origin.x + bounds.size.width
        {
            boundingVector.dx = -boundaryAvoidance
        }

        if agent.position.y < bounds.origin.y
        {
            boundingVector.dy = boundaryAvoidance
        }
        else if agent.position.y > bounds.origin.y + bounds.size.height
        {
            boundingVector.dy = -boundaryAvoidance
        }
        
        if boundingVector != .zero // Avoid divide by 0 attempts
        {
            boundingVector = CGVector.normalize(vector: boundingVector)
            boundingVector = CGVector.multiply(vector: boundingVector, scalar: agent.attributes.boundingWeight)
        }
        
        return boundingVector
    }
}
