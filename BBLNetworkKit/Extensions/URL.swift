//
//  URL.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public extension URLSession {
    static func jsonSession(token: String?) -> URLSession {
        let config = URLSessionConfiguration.default
        var header = [ "Accept" : "application/json", "Content-Type" : "application/json"]
        if token != nil { header["Authorization"] = token! }
        config.httpAdditionalHeaders = header
        return URLSession(configuration: config)
    }
    
    static func deleteSession(token: String?) -> URLSession {
        let config = URLSessionConfiguration.default
        var header = [ "Content-Type" : "application/x-www-form-urlencoded" ]
        if token != nil { header["Authorization"] = token! }
        config.httpAdditionalHeaders = header
        return URLSession(configuration: config)
    }
    
    static func imageSession(token: String?) -> URLSession {
        let config = URLSessionConfiguration.default
        let header = [ "Accept" : "image" ]
        config.httpAdditionalHeaders = header
        return URLSession(configuration: config)
    }
    
    static func blobStorageSession(token: String?, mimeType: String) -> URLSession {
        let config = URLSessionConfiguration.default
        var header = [ "Accept" : mimeType ]
        if token != nil { header["Authorization"] = token! }
        config.httpAdditionalHeaders = header
        return URLSession(configuration: config)
    }
}

public extension URLRequest {
    static func GETRequest(url: URL, dictionary: [String: String]) -> URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems = dictionary.map { (key, value) in URLQueryItem(name: key, value: value) }
        guard let fullUrl = components.url else { return nil }
        let request = NSMutableURLRequest(url: fullUrl)
        request.httpMethod = "GET"
        return request as URLRequest
    }
    
    static func POSTRequest(url: URL, dictionary: [String: Any]) -> URLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return request as URLRequest
        }
        catch { return nil }
    }
    
    static func PUTRequest(url: URL, dictionary: [String: Any]) -> URLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            return request as URLRequest
        }
        catch { return nil }
    }
    
    static func DELETERequest(url: URL, dictionary: [String: String]) -> URLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
        let parameterString = self.parameterString(dictionary: dictionary)
        request.httpBody = parameterString.data(using: String.Encoding.utf8)
        return request as URLRequest
    }
    
    static func OPTIONSRequest(url: URL) -> URLRequest? {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "OPTIONS"
        return request as URLRequest
    }
    
    static func parameterString(dictionary: [String: String]) -> String {
        return dictionary.map { (param: (key: String, value: String)) -> String in
            return "\(param.key)=\(param.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            }.joined(separator: "&")
    }
}

public extension URLResponse {
    @objc var allHeaderFields: [AnyHashable: Any] {
        guard let response = self as? HTTPURLResponse else { return [:] }
        return response.allHeaderFields
    }
    
    @objc var statusCode: Int {
        guard let response = self as? HTTPURLResponse else { return 0 }
        return response.statusCode
    }
    
    var statusString: String {
        return HTTPURLResponse.localizedString(forStatusCode: self.statusCode)
    }
    
    var didSucceed: Bool {
        return 200...299 ~= self.statusCode
    }
    
    @objc var contentType: String {
        guard let response = self as? HTTPURLResponse,
            let contentType = response.allHeaderFields["Content-Type"] as? String  else { return "No Content-Type" }
        return contentType
    }
}

