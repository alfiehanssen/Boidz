//
//  CGPoint+Vector.swift
//  Boidz
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint
{
    static func add(points points: CGPoint...) -> CGPoint
    {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for point in points
        {
            x += point.x
            y += point.y
        }
        
        return CGPoint(x: x, y: y)
    }

    static func displace(point point: CGPoint, vector: CGVector) -> CGPoint
    {
        let x = point.x + vector.dx
        let y = point.y + vector.dy
        
        return CGPoint(x: x, y: y)
    }
 
    static func displacementVector(from from: CGPoint, to: CGPoint) -> CGVector
    {
        let dx = to.x - from.x
        let dy = to.y - from.y
        
        return CGVector(dx: dx, dy: dy)
    }

    static func distance(p1 p1: CGPoint, p2: CGPoint) -> CGFloat
    {
        let displacementVector = CGPoint.displacementVector(from: p1, to: p2)
        
        return CGVector.magnitude(vector: displacementVector)
    }
    
    static func divide(point point: CGPoint, scalar: CGFloat) -> CGPoint
    {
        assert(scalar != 0, "Attempt to divide point by 0.")
        
        let x = point.x / scalar
        let y = point.y / scalar
        
        return CGPoint(x: x, y: y)
    }
}

extension CGVector
{
    static func add(vectors vectors: CGVector...) -> CGVector
    {
        var dx: CGFloat = 0
        var dy: CGFloat = 0
        
        for vector in vectors
        {
            dx += vector.dx
            dy += vector.dy
        }
        
        return CGVector(dx: dx, dy: dy)
    }

    static func boundMagnitude(vector vector: CGVector, max: CGFloat) -> CGVector
    {
        guard CGVector.magnitude(vector: vector) > max else
        {
            return vector
        }
        
        var unitVector = CGVector.normalize(vector: vector)
        unitVector = CGVector.multiply(vector: unitVector, scalar: max)
        
        return unitVector
    }

    static func boundMagnitude(vector vector: CGVector, min: CGFloat) -> CGVector
    {
        guard CGVector.magnitude(vector: vector) < min else
        {
            return vector
        }
        
        var unitVector = CGVector.normalize(vector: vector)
        unitVector = CGVector.multiply(vector: unitVector, scalar: min)
        
        return unitVector
    }
    
    static func boundMagnitude(vector vector: CGVector, min: CGFloat, max: CGFloat) -> CGVector
    {
        let boundedVector = CGVector.boundMagnitude(vector: vector, min: min)
        
        return CGVector.boundMagnitude(vector: boundedVector, max: max)
    }

    static func divide(vector vector: CGVector, scalar: CGFloat) -> CGVector
    {
        assert(scalar != 0, "Attempt to divide vector by 0.")
        
        let dx = vector.dx / scalar
        let dy = vector.dy / scalar
        
        return CGVector(dx: dx, dy: dy)
    }

    static func magnitude(vector vector: CGVector) -> CGFloat
    {
        let x = pow(vector.dx, 2)
        let y = pow(vector.dy, 2)
        
        let sum = x + y
        
        return sqrt(sum)
    }

    static func multiply(vector vector: CGVector, scalar: CGFloat) -> CGVector
    {
        let dx = vector.dx * scalar
        let dy = vector.dy * scalar
        
        return CGVector(dx: dx, dy: dy)
    }
    
    static func normalize(vector vector: CGVector) -> CGVector
    {
        let magnitude = CGVector.magnitude(vector: vector)
        let unitVector = CGVector.divide(vector: vector, scalar: magnitude)
        
        return unitVector
    }
    
    static func subtract(v1 v1: CGVector, v2: CGVector) -> CGVector
    {
        let dx = v1.dx - v2.dx
        let dy = v1.dy - v2.dy
        
        return CGVector(dx: dx, dy: dy)
    }
}