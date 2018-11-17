//
//  BBLError.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 7/18/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

open class BBLError: Equatable {
    public var domain: String
    public var code: Int
    public var description: String
    public var recoverySuggestion: String?
    public var failureReason: String?
    public var url: URL?
    
    public init(domain: String, code: Int, description: String,
                recoverySuggestion: String? = nil, failureReason: String? = nil, url: URL? = nil) {
        self.domain = domain
        self.code = code
        self.description = description
        self.recoverySuggestion = recoverySuggestion
        self.failureReason = failureReason
    }
    
    public convenience init(errorObject: NSError) {
        self.init(domain: errorObject.domain,
                  code: errorObject.code,
                  description: errorObject.localizedDescription,
                  recoverySuggestion: errorObject.localizedRecoverySuggestion,
                  failureReason: errorObject.localizedFailureReason)
    }
    
    public convenience init(urlResponse: URLResponse) {
        self.init(domain: "HTTPErrorDomain",
                  code: urlResponse.statusCode,
                  description: HTTPURLResponse.localizedString(forStatusCode: urlResponse.statusCode),
                  recoverySuggestion: nil,
                  failureReason: urlResponse.allHeaderFields["Reason"] as? String,
                  url: urlResponse.url)
    }
    
    public static func ==(lhs: BBLError, rhs: BBLError) -> Bool {
        return lhs.domain == rhs.domain && lhs.code == rhs.code
    }
}

public enum BBLResult<T> {
    case success(T)
    case failure(BBLError)
    
    public func map<U>(_ f: (T) -> U) -> BBLResult<U> {
        switch self {
        case .success(let value):
            return .success(f(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func map<U>(_ f: (T) -> U?) -> BBLResult<U> {
        switch self {
        case .success(let value):
            if let outValue = f(value) {
                return .success(outValue)
            }
            return .failure(BBLMappingError)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func handle(success: (T) -> Void, failure: (BBLError) -> Void) {
        switch self {
        case .success(let t):
            success(t)
            
        case .failure(let error):
            failure(error)
        }
    }
}

// MARK: - Error Definitions
public let BBLURLError = BBLError(domain: "BBLErrorDomain", code: 600, description: "Invalid URL")
public let BBLInvalidObjectError = BBLError(domain: "BBLErrorDomain", code: 601, description: "Invalid object")
public let BBLConnectionError = BBLError(domain: "BBLErrorDomain", code: 602, description: "No internet connection")

public let BBLGETRequestError = BBLError(domain: "BBLErrorDomain", code: 610, description: "Bad GET request")
public let BBLPUTRequestError = BBLError(domain: "BBLErrorDomain", code: 611, description: "Bad PUT request")
public let BBLPATCHRequestError = BBLError(domain: "BBLErrorDomain", code: 612, description: "Bad PATCH request")
public let BBLPOSTRequestError = BBLError(domain: "BBLErrorDomain", code: 613, description: "Bad POST request")
public let BBLDELETERequestError = BBLError(domain: "BBLErrorDomain", code: 614, description: "Bad DELETE request")
public let BBLOPTIONSRequestError = BBLError(domain: "BBLErrorDomain", code: 615, description: "Bad OPTIONS request")

public let BBLNoDataError = BBLError(domain: "BBLErrorDomain", code: 630, description: "No data returned")
public let BBLMappingError = BBLError(domain: "BBLErrorDomain", code: 631, description: "Object mapping error")

public let BBLNoResponseError = BBLError(domain: "BBLErrorDomain", code: 640, description: "No response from server")

public let BBLJSONError = BBLError(domain: "BBLErrorDomain", code: 650, description: "Unexpected JSON object")
