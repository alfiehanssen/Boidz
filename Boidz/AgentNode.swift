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
    var identifier: String
    var velocity: CGVector
    
    init(position: CGPoint, velocity: CGVector)
    {
        self.identifier = NSProcessInfo.processInfo().globallyUniqueString
        self.velocity = velocity

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
