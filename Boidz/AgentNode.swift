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

class AgentNode: SKSpriteNode, Agent
{
    var identifier = NSProcessInfo.processInfo().globallyUniqueString
    var velocity: CGVector
    var attributes: AgentAttributes
    
    init(position: CGPoint, velocity: CGVector, attributes: AgentAttributes)
    {
        self.velocity = velocity
        self.attributes = attributes
        
        let color = UIColor.blackColor()
        let size = CGSize(width: 10, height: 10)
        super.init(texture: nil, color: color, size: size)

        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

struct BirdAttributes: AgentAttributes
{
    var alignmentWeight: CGFloat = 0.125
    var cohesionWeight: CGFloat = 0.01
    var maxSeparation: CGFloat = 20
    var minSpeed: CGFloat = 1
    var maxSpeed: CGFloat = 4
}
