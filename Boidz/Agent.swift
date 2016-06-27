//
//  Agent.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/26/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import Foundation
import CoreGraphics

func ==<T: Agent>(lhs: T, rhs: T) -> Bool
{
    return lhs.identifier == rhs.identifier
}

protocol Agent: Equatable
{
    var identifier: String { get set }
    var position: CGPoint { get set }
    var velocity: CGVector { get set }
    var attributes: AgentAttributes { get set }
}

protocol AgentAttributes
{
    /// A value between 0 and 1
    var alignmentWeight: CGFloat { get }

    /// A value between 0 and 1
    var cohesionWeight: CGFloat { get }
    
    var maxSeparation: CGFloat { get }
    
    var minSpeed: CGFloat { get }
    
    var maxSpeed: CGFloat { get }
}
