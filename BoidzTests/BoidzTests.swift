//
//  BoidzTests.swift
//  BoidzTests
//
//  Created by Alfred Hanssen on 6/25/16.
//  Copyright © 2016 Alfie Hanssen. All rights reserved.
//

import XCTest
@testable import Boidz

class BoidzTests: XCTestCase
{
    func testPointAddition()
    {
        let p1 = CGPoint(x: 2, y: 2)
        let p2 = CGPoint(x: 3, y: 3)
        
        let sumPoint = CGPoint.add(points: p1, p2)
        
        XCTAssert(sumPoint.x == 5, "x is expected to be 5")
        XCTAssert(sumPoint.y == 5, "y is expected to be 5")
    }
    
    func testPointDisplacement()
    {
        let point = CGPoint(x: 2, y: 2)
        let vector = CGVector(dx: 0, dy: 5)
        
        let displacedPoint = CGPoint.displace(point: point, vector: vector)
        
        XCTAssert(displacedPoint.x == 2, "x is expected to be 2")
        XCTAssert(displacedPoint.y == 7, "y is expected to be 7")
    }
    
    func testPointDisplacementVector()
    {
        let p1 = CGPoint(x: 2, y: 2)
        let p2 = CGPoint(x: 3, y: 3)
        
        let vector = CGPoint.displacementVector(from: p1, to: p2)

        XCTAssert(vector.dx == 1, "dx is expected to be 1")
        XCTAssert(vector.dy == 1, "dy is expected to be 1")
    }
    
    func testPointDistance()
    {
        let p1 = CGPoint(x: 2, y: 2)
        let p2 = CGPoint(x: 3, y: 3)

        let distance = CGPoint.distance(p1: p1, p2: p2)
        
        XCTAssert(distance == sqrt(2), "distance is expected to be sqrt(2)")
    }
    
    func testPointDivision()
    {
        let point = CGPoint(x: 10, y: 10)
        let scalar: CGFloat = 3
        
        let scaledPoint = CGPoint.divide(point: point, scalar: scalar)
        
        XCTAssert(scaledPoint.x == 10/3, "x is expected to be 10/3")
        XCTAssert(scaledPoint.y == 10/3, "y is expected to be 10/3")
    }
    
    func testVectorAddition()
    {
        let v1 = CGVector(dx: 0, dy: 5)
        let v2 = CGVector(dx: 10, dy: 8)
        
        let sumVector = CGVector.add(vectors: v1, v2)
        
        XCTAssert(sumVector.dx == 10, "dx is expected to be 10")
        XCTAssert(sumVector.dy == 13, "dy is expected to be 13")
    }

    func testMagnitudeBoundingMin()
    {
        let vector = CGVector(dx: 0, dy: 5)
        let min: CGFloat = 10
        
        let magnitude = CGVector.magnitude(vector: vector)
        XCTAssert(magnitude < min, "To test properly, original magnitude must be less than the min magnitude.")
        
        let boundVector = CGVector.boundMagnitude(vector: vector, min: min)
        let newMagnitude = CGVector.magnitude(vector: boundVector)

        XCTAssert(newMagnitude >= min, "Bound magnitude is expected to be greater than or equal to the minimum.")
    }

    func testMagnitudeBoundingMax()
    {
        let vector = CGVector(dx: 0, dy: 5)
        let max: CGFloat = 3

        let magnitude = CGVector.magnitude(vector: vector)
        XCTAssert(magnitude > max, "To test properly, original magnitude must be greater than the max magnitude.")

        let boundVector = CGVector.boundMagnitude(vector: vector, max: max)
        let newMagnitude = CGVector.magnitude(vector: boundVector)

        XCTAssert(newMagnitude <= max, "Bound magnitude is expected to be less than or equal to the maximum.")
    }

    func testMagnitudeBoundingMinMax()
    {
        let vector = CGVector(dx: 0, dy: 5)
        var min: CGFloat = 10
        var max: CGFloat = 15
        
        let magnitude = CGVector.magnitude(vector: vector)
        XCTAssert(magnitude < min, "To test properly, original magnitude must be less than the min magnitude.")

        var boundVector = CGVector.boundMagnitude(vector: vector, min: min, max: max)
        var newMagnitude = CGVector.magnitude(vector: boundVector)

        XCTAssert(newMagnitude >= min, "Bound magnitude is expected to be greater than or equal to the minimum.")
        XCTAssert(newMagnitude <= max, "Bound magnitude is expected to be less than or equal to the maximum.")

        min = 0
        max = 2
        
        XCTAssert(magnitude > max, "To test properly, original magnitude must be greater than the max magnitude.")

        boundVector = CGVector.boundMagnitude(vector: vector, min: min, max: max)
        newMagnitude = CGVector.magnitude(vector: boundVector)
        
        XCTAssert(newMagnitude >= min, "Bound magnitude is expected to be greater than or equal to the minimum.")
        XCTAssert(newMagnitude <= max, "Bound magnitude is expected to be less than or equal to the maximum.")
    }

    func testVectorDivision()
    {
        let vector = CGVector(dx: 2, dy: 5)
        let scalar: CGFloat = 4
        
        let scaledVector = CGVector.divide(vector: vector, scalar: scalar)
        
        XCTAssert(scaledVector.dx == 2/4, "dx is expected to be 2/4")
        XCTAssert(scaledVector.dy == 5/4, "dy is expected to be 5/4")
    }

    func testVectorMagnitude()
    {
        let vector = CGVector(dx: 2, dy: 5)

        let magnitude = CGVector.magnitude(vector: vector)
        
        XCTAssert(magnitude == sqrt(29), "magnitude is expected to be sqrt(29)")
    }

    func testVectorMultiplication()
    {
        let vector = CGVector(dx: 0, dy: 5)
        let scalar: CGFloat = 4
        
        let scaledVector = CGVector.multiply(vector: vector, scalar: scalar)
        
        XCTAssert(scaledVector.dx == 0, "dx is expected to be 0")
        XCTAssert(scaledVector.dy == 20, "dy is expected to be 20")
    }
    
    func testVectorNormalization()
    {
        let vector = CGVector(dx: 0, dy: 5)
        
        let unitVector = CGVector.normalize(vector: vector)
        let magnitude = CGVector.magnitude(vector: unitVector)
        
        XCTAssert(magnitude == 1, "Magnitude of the unit vector is expected to be 1.")
    }

    func testVectorSubtraction()
    {
        let v1 = CGVector(dx: 0, dy: 5)
        let v2 = CGVector(dx: 10, dy: 8)
        
        let subVector = CGVector.subtract(v1: v1, v2: v2)
        
        XCTAssert(subVector.dx == -10, "dx is expected to be -10")
        XCTAssert(subVector.dy == -3, "dy is expected to be -3")
    }
    
    func testAngle()
    {
        var v1 = CGVector(dx: 0, dy: 5)
        var v2 = CGVector(dx: 0, dy: 5)
        var angle = CGVector.angle(v1: v1, v2: v2)
        XCTAssert(angle == 0, "Angle is expected to be 0.")

        v1 = CGVector(dx: 0, dy: 5)
        v2 = CGVector(dx: 0, dy: -5)
        angle = CGVector.angle(v1: v1, v2: v2)
        XCTAssert(angle == 180, "Angle is expected to be 180.")
    
        v1 = CGVector(dx: 0, dy: 5)
        v2 = CGVector(dx: 5, dy: 0)
        angle = CGVector.angle(v1: v1, v2: v2)
        XCTAssert(angle == 90, "Angle is expected to be 90.")
    }
}
