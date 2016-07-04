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
    
    /// A value between 0 and 1
    var separationWeight: CGFloat { get }

    /// A value between 0 and 1
    var boundingWeight: CGFloat { get }
    
    var neighborhoodDistance: CGFloat { get }
    
    var maxSeparation: CGFloat { get }
    
    var minSpeed: CGFloat { get }
    
    var maxSpeed: CGFloat { get }
}
