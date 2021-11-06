//
//  FeedErrorHandler.swift
//  SwiftNews
//
//  Created by Rob Maltese on 11/5/21.
//

import Foundation

/**
 `FeedErrorhandler` conforms to type Error which will return us an error code that we will then handle.
 - returns :
 - parseError:
    If the data failed to parse, it will throw a parseing error.
 - errorCode:
    If the website is offline or there's an issue getting to our feed, it will throw an error code.
 - unknown:
    Unknown handles all other errors.
 */
enum FeedError: Error {
    case parseError
    case errorCode(Int)
    case unknown
}

extension FeedError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parseError:
            return "Failed to parse the feed data."
        case .errorCode(let code):
            return "\(code) - Something went wrong!"
        case .unknown:
            return "An unknown error has occurred!"
        }
    }
}
