//
//  TieCloseSessionResponse.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation

/**
 The response of the engine for closeSession call
 */
@objc public class TieCloseSessionResponse: NSObject, Codable {
    @objc public let status: Int
    @objc public let message: String

    init(status: Int, message: String) {
        self.status = status
        self.message = message

        super.init()
    }
}
