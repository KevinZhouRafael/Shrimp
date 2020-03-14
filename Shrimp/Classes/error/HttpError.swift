//
//  HttpError.swift
//  Shrimp
//
//  Created by Kevin Zhou on 2020/3/14.
//  Copyright © 2020 kai zhou. All rights reserved.
//

import Foundation

public struct HttpError:Error {
    public let statusCode:HttpStatusCode
    public let code:Int
    
    public init(code:Int) {
        self.code = code
        statusCode = HttpStatusCode(statusCode: code)
    }
}

extension HttpError: LocalizedError {
    public var errorDescription: String? {
//        return "status code: \(code), description: \( HttpStatusCode(statusCode: code).statusDescription)"
        return HttpStatusCode(statusCode: code).statusDescription
    }
}
