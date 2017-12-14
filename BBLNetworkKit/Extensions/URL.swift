//
//  URL.swift
//  BBLNetworkKit
//
//  Created by Joel Perry on 3/26/16.
//  Copyright © 2016 Joel Perry. All rights reserved.
//

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

