//
//  TieResponse.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation

/**
 Successful response from the engine
 */
@objc public class TieResponse: NSObject, Codable {
    @objc public let status: Int
    @objc public let input: TieInput
    @objc public let output: TieOutput
    @objc public let sessionId: String

    init(status: Int, input: TieInput, output: TieOutput, sessionId: String) {
        self.status = status
        self.input = input
        self.output = output
        self.sessionId = sessionId

        super.init()
    }
}
