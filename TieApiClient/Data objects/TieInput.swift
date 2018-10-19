//
//  TieInput.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation
/**
 The user-supplied input as read by the engine
 */
@objc public class TieInput: NSObject, Codable {
    @objc public let text: String
    @objc public let parameters: [String: String]?

    init(text: String, parameters: [String: String]?) {
        self.text = text
        self.parameters = parameters

        super.init()
    }
}
