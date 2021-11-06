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
            let description = xml.channel.xml?[.key("description")].xml?.xmlValue
            let pubDate = xml.channel.xml?.pubDate.xml?.xmlValue
            
            let items = xml.channel.xml?.item.xmlList
            
            XCTAssertNotNil(title)
            XCTAssertNotNil(pubDate)
            XCTAssertNotNil(description)
            XCTAssertNotNil(items)
            
            let firstItem = items![0]
            
            print(firstItem.xmlChildren.map(\.xmlName))
            
            let firstItemGUID = firstItem.guid.xml?.xmlValue
            let firstItemTitle = firstItem.title.xml?.xmlValue
            let firstItemDescription = firstItem[.key("description")].xml?.xmlValue
            let firstItemLink = firstItem.link.xml?.xmlValue
            let firstItemPubDate = firstItem.pubDate.xml?.xmlValue
            let firstItemContent = firstItem[.key("content:encoded")].xml?.xmlValue
            
            XCTAssertNotNil(firstItemGUID)
            XCTAssertNotNil(firstItemTitle)
            XCTAssertNotNil(firstItemLink)
            XCTAssertNotNil(firstItemDescription)
            XCTAssertNotNil(firstItemPubDate)
            XCTAssertNotNil(firstItemContent)
        }
        
        task.resume()
        sema.wait()
    }
}
