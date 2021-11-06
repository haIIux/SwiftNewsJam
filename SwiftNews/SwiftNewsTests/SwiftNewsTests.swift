//
//  SwiftNewsTests.swift
//  SwiftNewsTests
//
//  Created by Leif on 11/5/21.
//

import XCTest
@testable import SwiftNews

import SwiftyXML

class SwiftNewsTests: XCTestCase {
    func testXMLSwiftBySundellParsing() throws {
        let sema = DispatchSemaphore(value: 0)
        
        let task = FeedURL.sundell
            .fetch()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail()
                    sema.signal()
                }
            }) { articles in
                
            XCTAssertNotEqual(articles.count, 0)
            XCTAssertEqual(articles.count, 100)
                
            sema.signal()
        }
        
        sema.wait()
        task.cancel()
    }
}
