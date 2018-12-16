//
//  BBLError.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 7/18/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public enum BBLError: LocalizedError {
    case generic(String)
    case invalidObject
    case invalidRequest
    case task(NSError)
    case jsonDeserialize(NSError, Data?)
    case urlResponse(URLResponse, Data?)
    
    public var code: Int? {
        switch self {
        case .generic, .invalidObject, .invalidRequest: return nil
        case .jsonDeserialize(let error, _), .task(let error): return error.code
        case .urlResponse(let response, _): return response.statusCode
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .generic(let message): return message
        case .invalidObject: return "Invalid object"
        case .invalidRequest: return "Invalid request"
        case .jsonDeserialize(let error, _), .task(let error): return error.localizedDescription
        case .urlResponse(let response, _): return response.statusString
        }
    }
}

public enum BBLResult<T> {
    case success(T)
    case failure(Error)
    
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
            return .failure(BBLError.invalidObject)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func handle(success: (T) -> Void, failure: (Error) -> Void) {
        switch self {
        case .success(let t):
            success(t)
            
        case .failure(let error):
            failure(error)
        }
    }
}

