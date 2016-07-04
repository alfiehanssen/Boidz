//
//  AgentNode.swift
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
import SpriteKit

class AgentNode: SKShapeNode, Agent
{
    var identifier = NSProcessInfo.processInfo().globallyUniqueString
    
    var velocity: CGVector
    {
        didSet
        {
            self.setRotation(velocity: self.velocity)
        }
    }

    var previousVelocity: CGVector

    var attributes: AgentAttributes

    init(position: CGPoint, velocity: CGVector, attributes: AgentAttributes)
    {
        self.velocity = velocity
        self.previousVelocity = .zero
        self.attributes = attributes
        
        super.init()
        
        self.path = self.dynamicType.shapePath(16)
        self.fillColor = UIColor.greenColor()
        self.position = position
        
        self.setRotation(velocity: self.velocity)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private static func shapePath(sideLength: Double) -> CGPath
    {
        let side = 16
        let path = UIBezierPath()
        let point1 = CGPoint(x: 0, y: side/2)
        let point2 = CGPoint(x: 0, y: -side/2)
        let point3 = CGPoint(x: side, y: 0)
        
        path.moveToPoint(point1)
        path.addLineToPoint(point2)
        path.addLineToPoint(point3)
        path.addLineToPoint(point1)
        
        return path.CGPath
    }
    
    // MARK: Private API
    
    private func setRotation(velocity velocity: CGVector)
    {
        self.zRotation = atan2(velocity.dy, velocity.dx)
    }
}

struct BirdAttributes: AgentAttributes
{
    var alignmentWeight: CGFloat = 0.1
    var cohesionWeight: CGFloat = 0.01
    var separationWeight: CGFloat = 0.1
    var boundingWeight: CGFloat = 0.5
    
    var neighborhoodRadius: CGFloat = 40
    var minSeparation: CGFloat = 20
    var minSpeed: CGFloat = 2
    var maxSpeed: CGFloat = 5
}
