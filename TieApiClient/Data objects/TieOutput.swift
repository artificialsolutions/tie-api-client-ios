//
//  TieOutput.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation

/**
 The response of the engine
 */
@objc public class TieOutput: NSObject, Codable {
    @objc public let text: String
    @objc public let emotion: String?
    @objc public let link: String?
    @objc public let parameters: [String: String]?

    init(text: String, emotion: String?, link: String?, parameters: [String: String]?) {
        self.text = text
        self.emotion = emotion
        self.link = link
        self.parameters = parameters
    }
}
