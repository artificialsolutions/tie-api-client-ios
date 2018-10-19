//
//  ResponseParsingTests.swift
//  TieApiClientTests
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import XCTest
@testable import TieApiClient

class ResponseParsingTests: XCTestCase {
    
    private let decoder = JSONDecoder()

    override func setUp() {
        super.setUp()

        try? TieApiService.sharedInstance.setup(TieApiTestConstants.baseUrl, endpoint: TieApiTestConstants.endpoint)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testValidResponses() {
        let validResponses = [
            """
            {
                "status": 0,
                "input": {
                    "text": "Who am I?",
                    "parameters": {
                        "param1": "value1"
                    }
                },
                "output": {
                    "text": "Safetynet",
                    "emotion": "happy",
                    "link": "https://example.com",
                    "parameters": {}
                },
                "sessionId": "CA067014750B374BFE0190843F6ADA19"
            }
            """,
            """
            {
                "status": 0,
                "input": {
                    "text": "My name is Luke Skywalker",
                },
                "output": {
                    "text": "Luke is a nice name",
                    "emotion": "",
                    "link": "",
                    "parameters": {}
                },
                "sessionId": "randomSessionId"
            }
            """
        ]

        for response in validResponses {
            let resp = try? decoder.decode(TieResponse.self, from: response.data(using: .utf8)!)
            XCTAssert(resp != nil, "Parsing of \(resp) failed")
        }
    }

    func testInvalidResponses() {
        let invalidResponses = [
            """
            {
                "input": {
                    "text": "Who am I?",
                    "parameters": {
                        "param1": "value1"
                    }
                },
                "output": {
                    "text": "Safetynet",
                    "emotion": "happy",
                    "link": "https://example.com",
                    "parameters": {}
                },
                "sessionId": "CA067014750B374BFE0190843F6ADA19"
            }
            """,
            """
            {
                "status": 0,
                "input": {
                    "text": "My name is Luke Skywalker",
                },
                "output": {
                    "text": "Luke is a nice name",
                    "emotion": "",
                    "link": "",
                    "parameters": {}
                },
                "session": "randomSessionId"
            }
            """
        ]

        for response in invalidResponses {
            let resp = try? decoder.decode(TieResponse.self, from: response.data(using: .utf8)!)
            XCTAssert(resp == nil, "Parsing of invalid response '\(resp)' succeeded")
        }
    }
}
