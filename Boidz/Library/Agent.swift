//
//  Agent.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/26/16.
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

/// An overload of the == operator that specifies how agent equality is evaluated.
func ==<T: Agent>(lhs: T, rhs: T) -> Bool
{
    return lhs.identifier == rhs.identifier
}

/// A protocol that defines the basic operties of an autonymous agent.
protocol Agent: Equatable
{
    /// A unique identifier used to test agent equality.
    var identifier: String { get set }
    
    /// The position of the agent.
    var position: CGPoint { get set }

    /// The velocity of the agent. Used to modify the agent's position.
    var velocity: CGVector { get set }

    /// The velocity of the agent at the previous iteration of the simulation.
    var previousVelocity: CGVector { get set }
    
    /// A set of attributes that define how the agent navigates in space.
    var attributes: AgentAttributes { get set }
}

/// A protocol that defines a set of attributes that determine how an autonymous agent navigates in space.
protocol AgentAttributes
{
    /// A value between 0 and 1. An agent's alignment vector is multiplied by this weight to achieve a dampened alignment.
    var alignmentWeight: CGFloat { get }

    /// A value between 0 and 1. An agent's cohesion vector is multiplied by this weight to achieve a dampened cohesion.
    var cohesionWeight: CGFloat { get }
    
    /// A value between 0 and 1. An agent's separation vector is multiplied by this weight to achieve a dampened separation.
    var separationWeight: CGFloat { get }

    /// A value between 0 and 1. An agent's bounding vector is multiplied by this weight to achieve a dampened bounding.
    var boundingWeight: CGFloat { get }
    
    /// The radius of a circle with center equal to the agent's position. This circle represents the agent's field of awareness.
    var neighborhoodRadius: CGFloat { get }

    var neighborhoodAngle: CGFloat { get }

    var wanderRate: CGFloat { get }
    
    var wanderStrength: CGFloat { get }
    
    /// The distance an agent can be to a neighbor before it begins to navigate away from the neighbor (via a separation vector).
    var minSeparation: CGFloat { get }
    
    /// The minimum speed an agent can be moving. The velocity vector is clamped against this value.
    var minSpeed: CGFloat { get }
    
    /// The maximum speed an agent can be moving. The velocity vector is clamped against this value.
    var maxSpeed: CGFloat { get }
}
