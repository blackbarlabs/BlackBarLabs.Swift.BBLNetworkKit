//
//  BBLKeychain.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation
import Security

public struct BBLKeychain {
    
    // MARK: - Properties
    let tokenKey: String
    
    // MARK: - Init
    public init(tokenKey: String) {
        self.tokenKey = tokenKey
    }
    
    // MARK: - Convenience
    public func fetchToken() -> String? {
        let fetch = get(key: tokenKey)
        if fetch.status != errSecSuccess { print("Error \(fetch.status) fetching token") }
        return fetch.value
    }
    
    public func saveToken(value: String) {
        let status = set(key: tokenKey, value: value)
        if status != errSecSuccess { print("Error \(status) saving token") }
    }
    
    public func deleteToken() {
        let status = delete(key: tokenKey)
        if status != errSecSuccess { print("Error \(status) deleting token") }
    }
    
    // MARK: - Private
    private func get(key: String) -> (value: String?, status: OSStatus) {
        let query: [NSString: AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecReturnData : kCFBooleanTrue,
            kSecMatchLimit : kSecMatchLimitOne
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query, &data)
        if status != 0 { return (nil, status) }
        if let valueData = data, let value = NSString(data: valueData as! Data, encoding: String.Encoding.utf8.rawValue) as? String {
            return (value, status)
        }
        return (nil, status)
    }
    
    private func set(key: String, value: String) -> OSStatus {
        guard let valueData = value.data(using: String.Encoding.utf8) else { return errSecParam }
        
        let query: [NSString: AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key,
            kSecValueData : valueData
        ]
        
        var status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem {
            let update: [NSString: AnyObject] = [ kSecValueData : valueData ]
            status = SecItemUpdate(query, update)
        }
        return status
    }
    
    private func delete(key: String) -> OSStatus {
        let query: [NSString: AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : key
        ]
        return SecItemDelete(query)
    }
}

