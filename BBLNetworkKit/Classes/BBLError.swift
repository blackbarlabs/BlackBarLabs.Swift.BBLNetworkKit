//
//  BBLError.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 7/18/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public enum BBLError: LocalizedError {
    case decoding(DecodingError)
    case generic(String)
    case invalidObject
    case invalidRequest
    case task(NSError)
    case urlResponse(URLResponse, Data?)
    
    public var code: Int? {
        switch self {
        case .decoding, .generic, .invalidObject, .invalidRequest: return nil
        case .task(let error): return error.code
        case .urlResponse(let response, _): return response.statusCode
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .decoding(let error): return error.localizedDescription
        case .generic(let message): return message
        case .invalidObject: return "Invalid object"
        case .invalidRequest: return "Invalid request"
        case .task(let error): return error.localizedDescription
        case .urlResponse(let response, _): return response.statusString
        }
    }
}

public enum BBLResult<Value> {
    case value(Value)
    case error(Error)
    
    public func handle(value: (Value) -> Void, error: (Error) -> Void) {
        switch self {
        case .value(let v): value(v)
        case .error(let e): error(e)
        }
    }
}

