//
//  BBLError.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 7/18/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public struct BBLError {
    public var domain: String
    public var code: Int
    public var description: String
    public var recoverySuggestion: String?
    public var failureReason: String?
    
    public init(domain: String, code: Int, description: String, recoverySuggestion: String?, failureReason: String?) {
        self.domain = domain
        self.code = code
        self.description = description
        self.recoverySuggestion = recoverySuggestion
        self.failureReason = failureReason
    }
    
    public init(errorObject: NSError) {
        self.init(domain: errorObject.domain,
                  code: errorObject.code,
                  description: errorObject.localizedDescription,
                  recoverySuggestion: errorObject.localizedRecoverySuggestion,
                  failureReason: errorObject.localizedFailureReason)
    }
    
    public init(urlResponse: URLResponse) {
        self.init(domain: "HTTPErrorDomain",
                  code: urlResponse.statusCode,
                  description: "HTTP Error \(urlResponse.statusCode)",
                  recoverySuggestion: nil,
                  failureReason:nil)
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
}

// MARK: - Error Definitions
public let BBLURLError = BBLError(domain: "BBLErrorDomain", code: 600, description: "Invalid URL", recoverySuggestion: nil, failureReason: nil)
public let BBLInvalidObjectError = BBLError(domain: "BBLErrorDomain", code: 601, description: "Invalid Object", recoverySuggestion: nil, failureReason: nil)

public let BBLGETRequestError = BBLError(domain: "BBLErrorDomain", code: 610, description: "Bad GET Request", recoverySuggestion: nil, failureReason: nil)
public let BBLPUTRequestError = BBLError(domain: "BBLErrorDomain", code: 611, description: "Bad PUT Request", recoverySuggestion: nil, failureReason: nil)
public let BBLPOSTRequestError = BBLError(domain: "BBLErrorDomain", code: 612, description: "Bad POST Request", recoverySuggestion: nil, failureReason: nil)
public let BBLDELETERequestError = BBLError(domain: "BBLErrorDomain", code: 613, description: "Bad DELETE Request", recoverySuggestion: nil, failureReason: nil)
public let BBLOPTIONSRequestError = BBLError(domain: "BBLErrorDomain", code: 614, description: "Bad OPTIONS Request", recoverySuggestion: nil, failureReason: nil)

public let BBLNoDataError = BBLError(domain: "BBLErrorDomain", code: 630, description: "No Data Returned", recoverySuggestion: nil, failureReason: nil)
public let BBLMappingError = BBLError(domain: "BBLErrorDomain", code: 631, description: "Object Mapping Error", recoverySuggestion: nil, failureReason: nil)

public let BBLJSONError = BBLError(domain: "BBLErrorDomain", code: 650, description: "Unexpected JSON Object", recoverySuggestion: nil, failureReason: nil)
