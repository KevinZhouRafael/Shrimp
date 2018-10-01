//
//  ShrimpError.swift
//  Shrimp
//
//  Created by rafael on 7/19/16.
//  Copyright © 2016 Rafael. All rights reserved.
//

import Foundation
public struct ShrimpError {
    public static let Domain = "com.Shrimp.error"
    
    
    public enum Code: Int {
        case inputStreamReadFailed           = -6000
        case outputStreamWriteFailed         = -6001
        case contentTypeValidationFailed     = -6002
        case statusCodeValidationFailed      = -6003
        case dataSerializationFailed         = -6004
        case stringSerializationFailed       = -6005
        case jsonSerializationFailed         = -6006
        case propertyListSerializationFailed = -6007
        case responseDecodingFailed            = -6008
    }
    
    public static func createError(_ code: Int) -> NSError {
        let text = HttpStatusCode(statusCode: code).statusDescription
        return NSError(domain: Domain, code: code, userInfo: [NSLocalizedDescriptionKey: text,NSLocalizedFailureReasonErrorKey:text])
    }
    
    public static func createError(_ code: Int, localizedDescription:String?) -> NSError {
        if localizedDescription == nil {
            return createError(code)
        }else{
            return NSError(domain: Domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription!,NSLocalizedFailureReasonErrorKey:localizedDescription!])
        }

    }
    
//    public static func errorWithCode(code: Code, failureReason: String) -> NSError {
//        return errorWithCode(code.rawValue, failureReason: failureReason)
//    }
//    
//    public static func errorWithCode(code: Int, failureReason: String) -> NSError {
//        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
//        return NSError(domain: Domain, code: code, userInfo: userInfo)
//    }
//    
//    static func error(domain domain: String = ShrimpError.Domain, code: Code, failureReason: String) -> NSError {
//        return error(domain: domain, code: code.rawValue, failureReason: failureReason)
//    }
//    
//    static func error(domain domain: String = ShrimpError.Domain, code: Int, failureReason: String) -> NSError {
//        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
//        return NSError(domain: domain, code: code, userInfo: userInfo)
//    }
}
