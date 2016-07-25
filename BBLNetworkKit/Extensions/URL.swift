//
//  URL.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

import Foundation

public extension NSURLSession {
    static func jsonSession(token token: String?) -> NSURLSession {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header = [ "Accept" : "application/json", "Content-Type" : "application/json"]
        if token != nil { header["Authorization"] = token! }
        config.HTTPAdditionalHeaders = header
        return NSURLSession(configuration: config)
    }
    
    static func deleteSession(token token: String?) -> NSURLSession {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header = [ "Content-Type" : "application/x-www-form-urlencoded" ]
        if token != nil { header["Authorization"] = token! }
        config.HTTPAdditionalHeaders = header
        return NSURLSession(configuration: config)
    }
    
    static func imageSession(token token: String?) -> NSURLSession {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let header = [ "Accept" : "image" ]
        config.HTTPAdditionalHeaders = header
        return NSURLSession(configuration: config)
    }
    
    static func blobStorageSession(token token: String?, mimeType: String) -> NSURLSession {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header = [ "Accept" : mimeType ]
        if token != nil { header["Authorization"] = token! }
        config.HTTPAdditionalHeaders = header
        return NSURLSession(configuration: config)
    }
}

public extension NSURLRequest {
    static func GETRequest(url url: NSURL, dictionary: [String: String]) -> NSURLRequest? {
        guard let urlString = url.absoluteString else { return nil }
        var parameterString = self.parameterString(dictionary: dictionary)
        if parameterString.characters.count > 0 { parameterString = "?" + parameterString }
        let fullString = urlString  + parameterString
        guard let fullUrl = NSURL(string: fullString) else { return nil }
        let request = NSMutableURLRequest(URL: fullUrl)
        request.HTTPMethod = "GET"
        return request
    }
    
    static func POSTRequest(url url: NSURL, dictionary: [String: AnyObject]) -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
            return request
        }
        catch { return nil }
    }
    
    static func PUTRequest(url url: NSURL, dictionary: [String: AnyObject]) -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
            return request
        }
        catch { return nil }
    }
    
    static func DELETERequest(url url: NSURL, dictionary: [String: String]) -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        let parameterString = self.parameterString(dictionary: dictionary)
        request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    static func parameterString(dictionary dictionary: [String: String]) -> String {
        return dictionary.map { (param: (key: String, value: String)) -> String in
            return "\(param.key)=\(param.value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!)"
            }.joinWithSeparator("&")
    }
}

public extension NSURLResponse {
    var statusCode: Int {
        guard let response = self as? NSHTTPURLResponse else { return 0 }
        return response.statusCode
    }
    
    var statusString: String {
        return NSHTTPURLResponse.localizedStringForStatusCode(self.statusCode)
    }
    
    var didSucceed: Bool {
        return 200...299 ~= self.statusCode
    }
    
    var contentType: String {
        guard let response = self as? NSHTTPURLResponse,
            contentType = response.allHeaderFields["Content-Type"] as? String  else { return "No Content-Type" }
        return contentType
    }
}

