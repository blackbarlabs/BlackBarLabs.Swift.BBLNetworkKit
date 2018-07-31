//
//  JSONConvertible.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String : Any]
public typealias JSONArray = [JSONDictionary]

// MARK: - Protocols
public protocol JSONConvertible {
    var identifier: UUID { get }
    init?(_ jsonDict: JSONDictionary)
}

public protocol JSONConvertibleType {
    var jsonValue: Any { get }
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
    
    func valueForJSONKey(_ key: Key) -> [String]? {
        return self[key] as? [String]
    }

    func valueForJSONKey(_ key: Key) -> [String] {
        return self[key] as? [String] ?? [String]()
    }
    
    func valueForJSONKey(_ key: Key) -> [String?] {
        return self[key] as? [String?] ?? []
    }
    
    func valueForJSONKey(_ key: Key) -> [Any]? {
        return self[key] as? [Any]
    }
    
    func valueForJSONKey(_ key: Key) -> [Any] {
        return self[key] as? [Any] ?? [Any]()
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
        guard let uuidString = self[key] as? String,
            uuidString != "00000000-0000-0000-0000-000000000000",
            let uuid = UUID(uuidString: uuidString) else { return nil }
        return uuid
    }
    
    // URL (optional only)
    func valueForJSONKey(_ key: Key) -> URL? {
        guard let urlString = self[key] as? String, let url = URL(string: urlString) else { return nil }
        return url
    }
    
    // NSDate (optional only)
    func valueForJSONKey(_ key: Key) -> Date? {
        if let value = self[key] as? Date { return value }
        guard let dateString = self[key] as? String else { return nil }
        return getDate(fromString: dateString)
    }
    
    func valueForJSONKey(_ key: Key) -> [Date?] {
        guard let array = self[key] as? [String?] else { return [] }
        return array.map({
            guard let dateString = $0 else { return nil }
            return getDate(fromString: dateString)
        })
    }
    
    private func getDate(fromString dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) { return date }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = formatter.date(from: dateString) { return date }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: dateString) { return date }
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: dateString)
    }
    
    // NSData (optional only)
    func valueForJSONKey(_ key: Key) -> Data? {
        if let value = self[key] as? Data { return value }
        guard let dataString = self[key] as? String, let data = dataString.data(using: .utf8) else { return nil }
        return data
    }
}

// MARK: - Setters
extension String: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension NSNumber: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension Bool: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension Int: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension Float: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension Double: JSONConvertibleType {
    public var jsonValue: Any { return self }
}

extension UUID: JSONConvertibleType {
    public var jsonValue: Any { return self.uuidString }
}

extension URL: JSONConvertibleType {
    public var jsonValue: Any { return self.absoluteString }
}

extension Date: JSONConvertibleType {
    public var jsonValue: Any {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ss'Z'"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}

extension Optional where Wrapped: JSONConvertibleType {
    public var jsonValue: Any {
        switch self {
        case .some(let s):
            return s.jsonValue
        case .none:
            return NSNull()
        }
    }
}
