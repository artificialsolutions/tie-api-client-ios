//
//  TieApiService.swift
//  TieApiClient
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import Foundation
/**
 Singleton client for interacting with the Teneo engine.
 
 Usage:
 ```
    // Set Teneo engine url
    try {
        TieApiService.sharedInstance.setup("{BASE_URL}", endpoint: "{ENDPOINT}")
    } catch {
        // Handle TieSetupError.invalidUrl
    }
 
    // Send input messages
    TieApiService.sharedInstance.sendInput({MESSAGE},
                                           parameters: {PARAMETERS},
                                           success: { response in
        // Handle response. Remember to dispatch to main thread if updating UI
    }, failure: { error in
        // Handle error
    })
 
    // Close session
     TieApiService.sharedInstance.closeSession({ response in
        //
     }, failure { error in
 
     })
 ```
 */
public class TieApiService: NSObject {
    /**
     Returns the shared TieApiService instance
     */
    @objc public static let sharedInstance = TieApiService()

    internal var session = URLSession(configuration: .default)
    private let userDefaults = UserDefaults()
    private var teneoEngineUrl: URL?

    private override init() {
        super.init()
    }

    /**
     Set Teneo engine URL.
     - Note: Must be called before calling sendInput or closeSession
     
     - Parameters:
        - baseUrl: Teneo engine base URL
        - endpoint: Teneo engine endpoint
     - Throws: TieError.invalidUrl if URL has an invalid syntax
     */
    @objc public func setup(_ baseUrl: String, endpoint: String?) throws {
        var url = URL(string: baseUrl)
        if let endpoint = endpoint {
            url?.appendPathComponent(endpoint)
        }

        guard let engineUrl = url else {
            throw TieError.invalidUrl
        }

        if engineUrl != self.teneoEngineUrl {
            userDefaults.removeObject(forKey: TieConstants.sessionIdKey)
            userDefaults.synchronize()
            self.teneoEngineUrl = engineUrl
        }
    }

    /**
     Send message to Teneo engine.
     
     - parameters:
        - message: Message to teneo engine
        - parameters: Arbitrary amount of key-value pairs for server
        - success: Closure executed after successfully receiving a response from Teneo engine.
                   Contains the response as TieResponse object
        - failure: Closure executed after failed attempt. Reason for failure as Error
     */
    @objc public func sendInput(_ message: String,
                                parameters: [String: String]? = nil,
                                success: ((TieResponse) -> Void)?,
                                failure: ((Error) -> Void)?) {
        guard let engineUrl = teneoEngineUrl else {
            failure?(TieError.uninitialized)
            return
        }

        var request = baseRequest(engineUrl)
        request.addValue(HttpConstants.wwwFormUrlencoded, forHTTPHeaderField: HttpConstants.contentType)

        let defaultParams: [String: String] = [
            "viewtype": ApiConstants.apiViewType,
            "userinput": message
        ]

        request.httpBody = bodyParameters(defaultParams, additionalParams: parameters)

        let task = session.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else {
                guard let error = error else {
                    // Response should always contain either data or error. Something unexpected happened if
                    // this gets executed
                    failure?(TieError.unknown)
                    return
                }
                // Network request failed
                failure?(error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let tieResponse = try decoder.decode(TieResponse.self, from: data)
                self?.userDefaults.set(tieResponse.sessionId, forKey: TieConstants.sessionIdKey)
                self?.userDefaults.synchronize()
                success?(tieResponse)
            } catch {
                do {
                    // Parsing of TieResponse failed. Let's try if we got an error response
                    let error = try decoder.decode(TieErrorResponse.self, from: data)
                    failure?(TieError.tieError(error))
                } catch {
                    // Teneo engine responded but it wasn't either TieResponse or TieErrorResponse.
                    // Will cause a DecodingError
                    failure?(error)
                }
            }
        }
        task.resume()
    }

    /**
     Close Teneo engine session
     
     - parameters:
        - success: Closure executed after Teneo engine session was successfully closed
        - failure: Closure executed after failure is closing a Teneo engine session
     */
    @objc public func closeSession(_ success: ((TieCloseSessionResponse) -> Void)?, failure: ((Error) -> Void)?) {
        guard let engineUrl = teneoEngineUrl else {
            failure?(TieError.uninitialized)
            return
        }

        let request = baseRequest(engineUrl, path: "/endsession")
        let task = session.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data else {
                guard let error = error else {
                    failure?(TieError.unknown)
                    return
                }
                failure?(error)
                return
            }

            let decoder = JSONDecoder()
            do {
                let resp = try decoder.decode(TieCloseSessionResponse.self, from: data)
                self?.userDefaults.removeObject(forKey: TieConstants.sessionIdKey)
                self?.userDefaults.synchronize()
                success?(resp)
            } catch {
                failure?(error)
            }
        }
        task.resume()
    }

    private func baseRequest(_ teneoEngineUrl: URL, path: String? = nil) -> URLRequest {
        var url = teneoEngineUrl
        if let path = path {
            url = url.appendingPathComponent(path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpConstants.post
        if let sessionId = userDefaults.string(forKey: TieConstants.sessionIdKey) {
            request.addValue("\(ApiConstants.cookiePrefix)\(sessionId)", forHTTPHeaderField: HttpConstants.cookie)
        }
        return request
    }

    private func bodyParameters(_ defaultParams: [String: String], additionalParams: [String: String]?) -> Data? {
        var combined = defaultParams

        if let additional = additionalParams {
            combined = combined.merging(additional, uniquingKeysWith: { (first, _) -> String in
                return first
            })
        }

        let array = combined.map { (entry) -> String in
            guard let key = entry.key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let value = entry.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return ""
            }
            return "\(key)=\(value)"
        }
        return array.joined(separator: "&").data(using: .utf8)
    }
}
