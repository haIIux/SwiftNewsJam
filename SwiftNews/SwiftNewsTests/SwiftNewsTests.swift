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
        
        let url = URL(string: "https://swiftbysundell.com/feed.rss")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { sema.signal() }
            let xml = XML(data: data!)!
            
            let title = xml.channel.xml?.title.xml?.xmlValue
//            let description = xml.channel.xml?..xml?.xmlValue
            let pubDate = xml.channel.xml?.pubDate.xml?.xmlValue
            
            let items = xml.channel.xml?.item.xmlList
            
//            dump(xml)
            
            XCTAssertNotNil(title)
            XCTAssertNotNil(pubDate)
            XCTAssertNotNil(items)
            
            let firstItem = items![0]
            
            dump(firstItem)
        }
        
        task.resume()
        sema.wait()
    }
}
