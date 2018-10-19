//
//  TieError.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation

enum TieError: Error {
    case invalidUrl
    case uninitialized
    case unknown
    case tieError(TieErrorResponse)
}
