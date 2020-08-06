//
//  MapStyleDrawerPositionTests.swift
//  MapStyleDrawerTests
//
//  Created by joshua kaunert on 8/5/20.
//  Copyright © 2020 Joshua Kaunert. All rights reserved.
//

import XCTest
import MapStyleDrawer

class DrawerPositionTests: XCTestCase {
    
    func testAdvance() {
        let positions: [DrawerPosition] = [.closed, .open]
        
        XCTAssertEqual(positions.advance(from: .closed, offset: 0), .closed)
        XCTAssertEqual(positions.advance(from: .closed, offset: 1), .open)
        XCTAssertEqual(positions.advance(from: .closed, offset: 2), nil)
        XCTAssertEqual(positions.advance(from: .open, offset: 1), nil)
        XCTAssertEqual(positions.advance(from: .open, offset: -1), .closed)
        XCTAssertEqual(positions.advance(from: .open, offset: -2), nil)
    }
    
    func testAdvanceWithEmpty() {
        let positions: [DrawerPosition] = []
        
        XCTAssertEqual(positions.advance(from: .open, offset: 1), nil)
        XCTAssertEqual(positions.advance(from: .open, offset: -1), nil)
        XCTAssertEqual(positions.advance(from: .closed, offset: 1), nil)
    }
    
    func testAdvanceWithNonexistent() {
        let positions: [DrawerPosition] = [.closed, .open, .partiallyOpen]
        
        XCTAssertEqual(positions.advance(from: .collapsed, offset: -1), nil)
        XCTAssertEqual(positions.advance(from: .collapsed, offset: 0), nil)
        XCTAssertEqual(positions.advance(from: .collapsed, offset: 1), nil)
    }
}

