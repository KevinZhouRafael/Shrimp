//
//  ShrimpError.swift
//  ShrimpHttp
//
//  Created by rafael on 7/19/16.
//  Copyright © 2016 Rafael. All rights reserved.
//

import Foundation
public struct ShrimpError {
    public static let Domain = "com.shrimphttp.error"
    
    
    public enum Code: Int {
        case InputStreamReadFailed           = -6000
        case OutputStreamWriteFailed         = -6001
        case ContentTypeValidationFailed     = -6002
        case StatusCodeValidationFailed      = -6003
        case DataSerializationFailed         = -6004
        case StringSerializationFailed       = -6005
        case JSONSerializationFailed         = -6006
        case PropertyListSerializationFailed = -6007
    }
    
    public static func createError(code: Int) -> NSError {
        let text = HttpStatusCode(statusCode: code).statusDescription
        return NSError(domain: Domain, code: code, userInfo: [NSLocalizedDescriptionKey: text,NSLocalizedFailureReasonErrorKey:text])
    }
    
    public static func createError(code: Int, localizedDescription:String?) -> NSError {
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
