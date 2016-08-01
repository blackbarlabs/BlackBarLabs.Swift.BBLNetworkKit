//
//  JSONConvertible.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [JSONDictionary]

// MARK: - Protocols
public protocol JSONConvertible {
    var identifier: UUID! { get }
    init?(_ jsonDict: JSONDictionary)
}

public protocol JSONConvertibleType {
    var jsonValue: AnyObject { get }
}

// MARK: - Getters
public extension Dictionary {
    
    // Dictionary
    func valueForJSONKey(_ key: Key) -> JSONDictionary? {
        return self[key] as? JSONDictionary
    }
    
    func valueForJSONKey(_ key: Key) -> JSONDictionary {
        return self[key] as? JSONDictionary ?? JSONDictionary()
    }
    
    // Array
    func valueForJSONKey(_ key: Key) -> JSONArray? {
        return self[key] as? JSONArray
    }
    
    func valueForJSONKey(_ key: Key) -> JSONArray {
        return self[key] as? JSONArray ?? JSONArray()
    }
    
    // String
    func valueForJSONKey(_ key: Key) -> String? {
        return self[key] as? String
    }
    
    func valueForJSONKey(_ key: Key) -> String {
        return self[key] as? String ?? ""
    }
    
    // NSNumber
    func valueForJSONKey(_ key: Key) -> NSNumber? {
        return self[key] as? NSNumber
    }
    
    func valueForJSONKey(_ key: Key) -> NSNumber {
        return self[key] as? NSNumber ?? 0
    }
    
    // Bool
    func valueForJSONKey(_ key: Key) -> Bool? {
        return self[key] as? Bool
    }
    
    func valueForJSONKey(_ key: Key) -> Bool {
        return self[key] as? Bool ?? false
    }
    
    // Int
    func valueForJSONKey(_ key: Key) -> Int? {
        return self[key] as? Int
    }
    
    func valueForJSONKey(_ key: Key) -> Int {
        return self[key] as? Int ?? 0
    }
    
    // Float
    func valueForJSONKey(_ key: Key) -> Float? {
        return self[key] as? Float
    }
    
    func valueForJSONKey(_ key: Key) -> Float {
        return self[key] as? Float ?? 0.0
    }
    
    // Double
    func valueForJSONKey(_ key: Key) -> Double? {
        return self[key] as? Double
    }
    
    func valueForJSONKey(_ key: Key) -> Double {
        return self[key] as? Double ?? 0.0
    }
    
    // UUID (optional only)
    func valueForJSONKey(_ key: Key) -> UUID? {
        if let uuidString = self[key] as? String, let uuid = UUID(uuidString: uuidString) { return uuid }
        else { return nil }
    }
    
    // URL (optional only)
    func valueForJSONKey(_ key: Key) -> URL? {
        if let urlString = self[key] as? String, let url = URL.init(string: urlString) { return url }
        else { return nil }
    }
    
    // NSDate (optional only)
    func valueForJSONKey(_ key: Key) -> Date? {
        if let value = self[key] as? Date { return value }
        if let dateString = self[key] as? String {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.date(from: dateString) { return date }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter.date(from: dateString)
        } else { return nil }
    }
    
    // NSData (optional only)
    func valueForJSONKey(_ key: Key) -> Data? {
        if let value = self[key] as? Data { return value }
        if let dataString = self[key] as? NSString, let data = dataString.data(using: String.Encoding.utf8.rawValue) { return data }
        else { return nil }
    }
}

// MARK: - Setters
extension String: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension NSNumber: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension Bool: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension Int: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension Float: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension Double: JSONConvertibleType {
    public var jsonValue: AnyObject { return self }
}

extension UUID: JSONConvertibleType {
    public var jsonValue: AnyObject { return self.uuidString }
}

extension URL: JSONConvertibleType {
    public var jsonValue: AnyObject { return self.absoluteString ?? NSNull() }
}

extension Date: JSONConvertibleType {
    public var jsonValue: AnyObject {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ss'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}

extension Optional where Wrapped: JSONConvertibleType {
    public var jsonValue: AnyObject {
        switch self {
        case .some(_):
            return self!.jsonValue
        case .none:
            return NSNull()
        }
    }
}
