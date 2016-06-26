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
    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

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

    func testVectorSubtraction()
    {
        let v1 = CGVector(dx: 0, dy: 5)
        let v2 = CGVector(dx: 10, dy: 8)
        
        let subVector = CGVector.subtract(v1: v1, v2: v2)
        
        XCTAssert(subVector.dx == -10, "dx is expected to be -10")
        XCTAssert(subVector.dy == -3, "dy is expected to be -3")
    }
}
