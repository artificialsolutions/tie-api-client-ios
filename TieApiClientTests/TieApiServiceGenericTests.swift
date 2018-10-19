//
//  TieApiServiceGenericTests.swift
//  TieApiClientTests
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import XCTest
@testable import TieApiClient

class TieApiServiceGenericTests: XCTestCase {

    func testSendInputWithoutSetup() {
        TieApiService.sharedInstance.sendInput("My name is...", success: { (_) in
            XCTFail("Sending input should fail since setup wasn't called prior")
        }, failure: { (error) in
            XCTAssert(error is TieApiClient.TieError)
            if case TieApiClient.TieError.uninitialized = error {} else {
                XCTFail("Expected TieError.uninitialized")
            }
        })
    }

    func testCloseSessionWithoutSetup() {
        TieApiService.sharedInstance.closeSession({ (_) in
            XCTFail("Sending input should fail since setup wasn't called prior")
        }, failure: { (error) in
            XCTAssert(error is TieApiClient.TieError)
            if case TieApiClient.TieError.uninitialized = error {} else {
                XCTFail("Expected TieError.uninitialized")
            }
        })
    }

    func testSetupTwice() {
        do {
            try TieApiService.sharedInstance.setup("http://domain.com", endpoint: "/endpoint")
            try TieApiService.sharedInstance.setup("http://anotherdomain.com", endpoint: "/endpoint")
        } catch {
            XCTFail("Calling setup twice in a row failed")
        }
    }

    func testSessionId() {
        let sessionId = "sessionId"
        let mockSession = URLSessionMock()
        let apiService = TieApiService.sharedInstance
        apiService.session = mockSession
        try? apiService.setup("http://domain.com", endpoint: "/endpoint/")

        mockSession.data =
            """
                {
                "status": 0,
                "input": {
                "text": ""
                },
                "output": {
                "text": ""
                },
                "sessionId": "\(sessionId)"
                }
                """.data(using: .utf8)
        apiService.sendInput("", success: nil, failure: nil)
        apiService.sendInput("", success: nil, failure: nil)
        guard let headers = mockSession.lastRequest?.allHTTPHeaderFields else {
            XCTFail("Request did not contain any headers")
            return
        }
        XCTAssert(headers.count == 2)
        XCTAssert(headers["Cookie"] == "JSESSIONID=\(sessionId)")
    }

    func testRemoveSessionId() {
        let mockSession = URLSessionMock()
        let apiService = TieApiService.sharedInstance
        apiService.session = mockSession
        try? apiService.setup("http://domain.com", endpoint: "/endpoint/")

        let sessionId = "sessionId"
        let sendInputReponse =
        """
        {
            "status": 0,
            "input": {
                "text": ""
            },
            "output": {
                "text": ""
            },
            "sessionId": "\(sessionId)"
        }
        """.data(using: .utf8)

        mockSession.data = sendInputReponse

        apiService.sendInput("", success: nil, failure: nil)
        apiService.sendInput("", success: nil, failure: nil)
        guard let headers = mockSession.lastRequest?.allHTTPHeaderFields else {
            XCTFail("Request did not contain any headers")
            return
        }
        XCTAssert(headers.count == 2)
        XCTAssert(headers["Cookie"] == "JSESSIONID=\(sessionId)")

        let closeSessionResponse =
        """
        {
            "status": 1,
            "message": "logout"
        }
        """.data(using: .utf8)

        mockSession.data = closeSessionResponse
        apiService.closeSession(nil, failure: nil)

        mockSession.data = sendInputReponse
        apiService.sendInput("", success: nil, failure: nil)
        guard let newHeaders = mockSession.lastRequest?.allHTTPHeaderFields else {
            XCTFail("Request did not contain any headers")
            return
        }

        XCTAssert(newHeaders.count == 1)
        XCTAssert(newHeaders["Cookie"] == nil)
    }

}
