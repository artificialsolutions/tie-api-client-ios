//
//  TieErrorResponse.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation

/**
 The error response of the engine
 */
@objc public class TieErrorResponse: NSObject, Codable {
    @objc public let status: Int
    @objc public let input: TieInput?
    @objc public let message: String

    init(status: Int, input: TieInput?, message: String) {
        self.status = status
        self.input = input
        self.message = message

        super.init()
    }
}
