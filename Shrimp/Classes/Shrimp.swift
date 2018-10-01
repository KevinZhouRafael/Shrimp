//
//  Shrimp.swift
//  Shrimp
//
//  Created by kai zhou on 2018/9/29.
//  Copyright © 2018 kai zhou. All rights reserved.
//

import Foundation

public func request(
        _ method: Method,
        urlString: String,
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil)
        -> ShrimpRequest{
            return ShrimpRequest().request(method, urlString: urlString, parameters: parameters, headers: headers)
}

