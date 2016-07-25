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
    var identifier: NSUUID! { get }
    init?(_ jsonDict: JSONDictionary)
}

public protocol JSONConvertibleType {
    var jsonValue: AnyObject { get }
}

// MARK: - Getters
public extension Dictionary {
    
    // Dictionary
    func valueForJSONKey(key: Key) -> JSONDictionary? {
        return self[key] as? JSONDictionary
    }
    
    func valueForJSONKey(key: Key) -> JSONDictionary {
        return self[key] as? JSONDictionary ?? JSONDictionary()
    }
    
    // Array
    func valueForJSONKey(key: Key) -> JSONArray? {
        return self[key] as? JSONArray
    }
    
    func valueForJSONKey(key: Key) -> JSONArray {
        return self[key] as? JSONArray ?? JSONArray()
    }
    
    // String
    func valueForJSONKey(key: Key) -> String? {
        return self[key] as? String
    }
    
    func valueForJSONKey(key: Key) -> String {
        return self[key] as? String ?? ""
    }
    
    // NSNumber
    func valueForJSONKey(key: Key) -> NSNumber? {
        return self[key] as? NSNumber
    }
    
    func valueForJSONKey(key: Key) -> NSNumber {
        return self[key] as? NSNumber ?? 0
    }
    
    // Bool
    func valueForJSONKey(key: Key) -> Bool? {
        return self[key] as? Bool
    }
    
    func valueForJSONKey(key: Key) -> Bool {
        return self[key] as? Bool ?? false
    }
    
    // Int
    func valueForJSONKey(key: Key) -> Int? {
        return self[key] as? Int
    }
    
    func valueForJSONKey(key: Key) -> Int {
        return self[key] as? Int ?? 0
    }
    
    // Float
    func valueForJSONKey(key: Key) -> Float? {
        return self[key] as? Float
    }
    
    func valueForJSONKey(key: Key) -> Float {
        return self[key] as? Float ?? 0.0
    }
    
    // Double
    func valueForJSONKey(key: Key) -> Double? {
        return self[key] as? Double
    }
    
    func valueForJSONKey(key: Key) -> Double {
        return self[key] as? Double ?? 0.0
    }
    
    // UUID (optional only)
    func valueForJSONKey(key: Key) -> NSUUID? {
        if let uuidString = self[key] as? String, uuid = NSUUID(UUIDString: uuidString) { return uuid }
        else { return nil }
    }
    
    // URL (optional only)
    func valueForJSONKey(key: Key) -> NSURL? {
        if let urlString = self[key] as? String, url = NSURL.init(string: urlString) { return url }
        else { return nil }
    }
    
    // NSDate (optional only)
    func valueForJSONKey(key: Key) -> NSDate? {
        if let value = self[key] as? NSDate { return value }
        if let dateString = self[key] as? String {
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = formatter.dateFromString(dateString) { return date }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter.dateFromString(dateString)
        } else { return nil }
    }
    
    // NSData (optional only)
    func valueForJSONKey(key: Key) -> NSData? {
        if let value = self[key] as? NSData { return value }
        if let dataString = self[key] as? NSString, data = dataString.dataUsingEncoding(NSUTF8StringEncoding) { return data }
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

extension NSUUID: JSONConvertibleType {
    public var jsonValue: AnyObject { return self.UUIDString }
}

extension NSURL: JSONConvertibleType {
    public var jsonValue: AnyObject { return self.absoluteString }
}

extension NSDate: JSONConvertibleType {
    public var jsonValue: AnyObject {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ss'Z'"
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter.stringFromDate(self)
    }
}

extension Optional where Wrapped: JSONConvertibleType {
    public var jsonValue: AnyObject {
        switch self {
        case .Some(_):
            return self!.jsonValue
        case .None:
            return NSNull()
        }
    }
}
