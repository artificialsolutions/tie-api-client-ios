//
//  TieApiCloseSessionTests.swift
//  TieApiClientTests
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import XCTest
@testable import TieApiClient

class TieApiCloseSessionTests: XCTestCase {

    let apiService = TieApiService.sharedInstance
    let mockSession = URLSessionMock()

    override func setUp() {
        super.setUp()

        try? apiService.setup(TieApiTestConstants.baseUrl, endpoint: TieApiTestConstants.endpoint)
        apiService.session = mockSession
    }

    func testCloseSessionSuccess() {
        let status = 1
        let message = "logout"
        mockSession.data = validCloseSessionRespose(status, message: message)

        let expectation = XCTestExpectation(description: #function)

        apiService.closeSession({
            XCTAssert($0.status == status)
            XCTAssert($0.message == message)
            expectation.fulfill()
        }, failure: {
            XCTFail($0.localizedDescription)
        })
        wait(for: [expectation], timeout: 20)
    }

    private func validCloseSessionRespose(_ status: Int, message: String) -> Data? {
        return """
            {
                "status": \(status),
                "message": "\(message)"
            }
        """.data(using: .utf8)
    }
}
