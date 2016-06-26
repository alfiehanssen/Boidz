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
}
