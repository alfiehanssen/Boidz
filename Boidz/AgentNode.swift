//
//  AgentNode.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/26/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
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

    var attributes: AgentAttributes

    init(position: CGPoint, velocity: CGVector, attributes: AgentAttributes)
    {
        self.velocity = velocity
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
    var alignmentWeight: CGFloat = 0.125
    var cohesionWeight: CGFloat = 0.01
    var separationWeight: CGFloat = 0.25
    var boundingWeight: CGFloat = 0.5
    var maxSeparation: CGFloat = 20
    var minSpeed: CGFloat = 1
    var maxSpeed: CGFloat = 4
}
