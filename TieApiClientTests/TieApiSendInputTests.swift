//
//  TieApiSendInputTests.swift
//  TieApiSendInputTests
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import XCTest
@testable import TieApiClient

class TieApiSendInputTests: XCTestCase {

    let apiService = TieApiService.sharedInstance
    let mockSession = URLSessionMock()
    let encoder = JSONEncoder()

    override func setUp() {
        super.setUp()

        try? apiService.setup(TieApiTestConstants.baseUrl, endpoint: TieApiTestConstants.endpoint)
        apiService.session = mockSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSendInputRequest() {
        mockSession.data = Data()
        apiService.sendInput("My name is Luke Skywalker", success: nil, failure: nil)
        let request = mockSession.lastRequest
        XCTAssert(request?.httpMethod == "POST")
        XCTAssert(request?.allHTTPHeaderFields?.count == 1)
        XCTAssert(request?.allHTTPHeaderFields!["Content-Type"] == "application/x-www-form-urlencoded")
        guard let body = request?.httpBody, let bodyStr = String(data: body, encoding: .utf8) else {
            XCTFail("Getting request body failed")
            return
        }
        let splitted = bodyStr.split(separator: "&")
        XCTAssert(splitted.count == 3)
        XCTAssert(splitted.contains("viewtype=tieapi"))
        XCTAssert(splitted.contains("userinput=My%20name%20is%20Luke%20Skywalker"))
    }

    func testSendInputParameter() {
        mockSession.data = Data()
        let parameters = ["param1Key": "param1Value"]
        apiService.sendInput("My name...", parameters: parameters, success: nil, failure: nil)
        guard let request = mockSession.lastRequest,
              let body = request.httpBody,
              let bodyStr = String(data: body, encoding: .utf8)
        else {
            XCTFail("Getting request body failed")
            return
        }
        let splitted = bodyStr.split(separator: "&")
        XCTAssert(splitted.count == 4)
        XCTAssert(splitted.contains("param1Key=param1Value"))
    }

    func testSendInputParameters() {
        let paramCount = 10
        mockSession.data = Data()
        var parameters = [String: String]()
        for index in 0..<paramCount {
            parameters["param\(index)Key"] = "param\(index)Value"
        }
        apiService.sendInput("My name...", parameters: parameters, success: nil, failure: nil)
        guard let request = mockSession.lastRequest,
              let body = request.httpBody,
              let bodyStr = String(data: body, encoding: .utf8)
        else {
            XCTFail("Getting request body failed")
            return
        }
        let components = bodyStr.components(separatedBy: "&")
        XCTAssert(components.count == (paramCount + 3))
        for index in 0..<paramCount {
            XCTAssert(components.contains("param\(index)Key=param\(index)Value"))
        }
    }

    func testSendInputResponseSuccess() {

        let expectedOutput = "Luke is a nice name"

        mockSession.data =
        """
        {
            "status": 0,
            "input": {
                "text": "My name is Luke Skywalker",
                "parameters": {}
            },
            "output": {
                "text": "\(expectedOutput)",
                "emotion": "",
                "link": "",
                "parameters": {}
            },
            "sessionId": "CA067014750B374BFE0190843F6ADA19"
        }
        """.data(using: .utf8)

        let expectation = XCTestExpectation(description: #function)
        apiService.sendInput("My name is Luke Skywalker", success: {
            XCTAssert($0.output.text == expectedOutput)
            expectation.fulfill()
        }, failure: {
            XCTFail($0.localizedDescription)
        })
        wait(for: [expectation], timeout: 20)
    }

    func testSendInputValidButMalformedJson() {
        mockSession.data =
            """
                {
                "validButMalformedJson": 0
                }
                """.data(using: .utf8)

        let expectation = XCTestExpectation(description: #function)
        apiService.sendInput("My name is Luke Skywalker", success: { _ in
            XCTFail("Parsing should have failed")
        }, failure: { _ in
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 20)
    }

    func testSendInputInvalidJson() {
        mockSession.data =
        """
            This is invalid json
        """.data(using: .utf8)

        apiService.sendInput("My name is...", success: { (_) in
            XCTFail("Parsing should have failed")
        }, failure: {
            XCTAssert($0 is DecodingError)
        })
    }

    func testSendInputErrorHandling() {
        mockSession.data = nil
        mockSession.error = TieError.unknown
        apiService.sendInput("My name is...", success: { (_) in
            XCTFail("Should have failed with TieError.unknown")
        }, failure: { (error) in
            XCTAssert(error is TieError)
            if case TieError.unknown = error {} else {
                XCTFail("Should have failed with TieError.unknown")
            }
        })
    }
}
