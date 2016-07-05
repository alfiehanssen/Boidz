//
//  CGPoint+Vector.swift
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

extension CGPoint
{
    /**
     Calculates the sum of a list of points.
     
     - parameter points: The list of points that will be summed.
     
     - returns: The point resulting from having summed all input `points`.
     */
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

    /**
     Displaces a point by a vector.
     
     - parameter point: The point to displace.
     - parameter vector: The vector used to displace the point.
     
     - returns: The point resulting from displacing `point` by `vector`.
     */
    static func displace(point point: CGPoint, vector: CGVector) -> CGPoint
    {
        let x = point.x + vector.dx
        let y = point.y + vector.dy
        
        return CGPoint(x: x, y: y)
    }
 
    /**
     Calculates the displacement vector between two points.
     
     - parameter from: The origin point of the displacement vector.
     - parameter to: The termination point of the displacement vector.
     
     - returns: The vector that represents the displacement of `to` with respect to `from`.
     */
    static func displacementVector(from from: CGPoint, to: CGPoint) -> CGVector
    {
        let dx = to.x - from.x
        let dy = to.y - from.y
        
        return CGVector(dx: dx, dy: dy)
    }

    /**
     Calculates the distance between two points.
     
     - parameter p1: The first point.
     - parameter p1: The second point.
     
     - returns: The scalar representing the distance between `p1` and `p2`.
     */
    static func distance(p1 p1: CGPoint, p2: CGPoint) -> CGFloat
    {
        let displacementVector = CGPoint.displacementVector(from: p1, to: p2)
        
        return CGVector.magnitude(vector: displacementVector)
    }
    
    /**
     Divides a point by a scalar.
     
     - parameter point: The point to divide.
     - parameter scalar: The scalar with which to divide the point.
     
     - returns: The point resulting from having divided `point` by `scalar`.
     */
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
    /**
     Calculates the sum of a list of vectors.
     
     - parameter vectors: The list of vectors that will be summed.
     
     - returns: The vector resulting from having summed all input `vectors`.
     */
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

    /**
     Modifies a vector by clamping its magnitude to a max value.
     
     - parameter vector: The vector whose magnitude will be clamped.
     - parameter min: The maximum allowable length of the vector's magnitude.
     
     - returns: The vector resulting from having clamped the magnitude of `vector` by `max`.
     */
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

    /**
     Modifies a vector by clamping its magnitude to a min value.
     
     - parameter vector: The vector whose magnitude will be clamped.
     - parameter min: The minimum allowable length of the vector's magnitude.
     
     - returns: The vector resulting from having clamped the magnitude of `vector` by `min`.
     */
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

    /**
     Modifies a vector by clamping its magnitude to a min and max value.
     
     - parameter vector: The vector whose magnitude will be clamped.
     - parameter min: The minimum allowable length of the vector's magnitude.
     - parameter max: The maximum allowable length of the vector's magnitude.
     
     - returns: The vector resulting from having clamped the magnitude of `vector` by `min` and `max`.
     */
    static func boundMagnitude(vector vector: CGVector, min: CGFloat, max: CGFloat) -> CGVector
    {
        let boundedVector = CGVector.boundMagnitude(vector: vector, min: min)
        
        return CGVector.boundMagnitude(vector: boundedVector, max: max)
    }

    /**
     Divides a vector by a scalar.
     
     - parameter vector: The vector to divide.
     - parameter scalar: The scalar with which to divide the vector.
     
     - returns: The vector resulting from having divided `vector` by `scalar`.
     */
    static func divide(vector vector: CGVector, scalar: CGFloat) -> CGVector
    {
        assert(scalar != 0, "Attempt to divide vector by 0.")
        
        let dx = vector.dx / scalar
        let dy = vector.dy / scalar
        
        return CGVector(dx: dx, dy: dy)
    }

    /**
     Calculates the magnitude of a vector.
     
     - parameter vector: The vector whose magnitude will be calculated.
     
     - returns: The magnitude of `vector`.
     */
    static func magnitude(vector vector: CGVector) -> CGFloat
    {
        let x = pow(vector.dx, 2)
        let y = pow(vector.dy, 2)
        
        let sum = x + y
        
        return sqrt(sum)
    }

    /**
     Multiplies a vector by a scalar.
     
     - parameter vector: The vector to multiply.
     - parameter scalar: The scalar by which to multiply the vector.
     
     - returns: The vector resulting from having multiplied `vector` by `scalar`.
     */
    static func multiply(vector vector: CGVector, scalar: CGFloat) -> CGVector
    {
        let dx = vector.dx * scalar
        let dy = vector.dy * scalar
        
        return CGVector(dx: dx, dy: dy)
    }
    
    /**
     Normalizes a vector.
     
     - parameter vector: The vector to normalize.
     
     - returns: The vector resulting from having normalized `vector`.
     */
    static func normalize(vector vector: CGVector) -> CGVector
    {
        let magnitude = CGVector.magnitude(vector: vector)
        let unitVector = CGVector.divide(vector: vector, scalar: magnitude)
        
        return unitVector
    }
    
    /**
     Subtracts one vector from another.
     
     - parameter v1: The vector to subtract `v2` from.
     - parameter v2: The vector to subtract from `v1`.
     
     - returns: The vector resulting from having subtracted `v2` from `v1`.
     */
    static func subtract(v1 v1: CGVector, v2: CGVector) -> CGVector
    {
        let dx = v1.dx - v2.dx
        let dy = v1.dy - v2.dy
        
        return CGVector(dx: dx, dy: dy)
    }
    
    /**
     Computes the dot product of two vectors.
     
     - parameter v1: The first vector.
     - parameter v2: The second vector.
     
     - returns: The scalar dot product.
     */
    static func dotProduct(v1 v1: CGVector, v2: CGVector) -> CGFloat // TODO: Test this. [AH] 7/5/2016
    {
        return (v1.dx * v2.dx) + (v1.dy * v2.dy)
    }

    /**
     Computes the angle in degrees between two vectors.
     
     - parameter v1: The first vector.
     - parameter v2: The second vector.
     
     - returns: The angle in degrees between `v1` and `v2`.
     */
    static func angle(v1 v1: CGVector, v2: CGVector) -> CGFloat
    {
        let normalized1 = CGVector.normalize(vector: v1)
        let normalized2 = CGVector.normalize(vector: v2)
        let dotProduct = CGVector.dotProduct(v1: normalized1, v2: normalized2)
        
        return acos(dotProduct) * (180 / CGFloat(M_PI))
    }
    
    /**
     Returns a vector with specified `magnitude` pointing in a random direction.
     
     - parameter magnitude: The magnitude to apple to the resulting vector.
     
     - returns: A vector pointing in a random direction with magnitude equal to `magnitude`.
     */
    static func random(magnitude magnitude: CGFloat) -> CGVector // TODO: Test this. [AH] 7/5/2016
    {
        let randomX = CGFloat(arc4random())
        let randomY = CGFloat(arc4random())
        let maxRandom = CGFloat(UINT32_MAX)
        
        let maxDegrees: CGFloat = 360
        let maxRadians = maxDegrees * (CGFloat(M_PI) / 180)
        
        let dx = cos((randomX / maxRandom) * maxRadians)
        let dy = sin((randomY / maxRandom) * maxRadians)
        
        let vector = CGVector(dx: dx, dy: dy)
        let normal = CGVector.normalize(vector: vector)

        return CGVector.multiply(vector: normal, scalar: magnitude)
    }
}