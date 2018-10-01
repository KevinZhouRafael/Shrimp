//
//  ShrimpBaseError.swift
//  KaoChong
//
//  Created by kai zhou on 27/02/2017.
//  Copyright © 2017 Kevin Zhou. All rights reserved.
//

import Foundation
public enum ShrimpBaseError: Error {
    
    public enum NetworkErrorReason{
        case noNetwork
        case httpStatusCode(error:Error)
    }
    
    public enum GlobaleErrorReason{
        case noData
        case dataSerialization(error:Error)
    }
    
    
    case networkError(reason:NetworkErrorReason)
    
    case globalError(reason:GlobaleErrorReason)
}

// MARK: - Error Booleans

public extension ShrimpBaseError {
    public var isNetworkError:Bool{
        if case .networkError = self { return true}
        return false
    }
    
    public var isGlobalError:Bool{
        if case .globalError = self {return true}
        return false
    }
    
}
// MARK: - Error Descriptions

extension ShrimpBaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
//        case .networkError(let error):
//            return "URL is not valid: \(error)"
        case .networkError(let reason):
            return reason.localizedDescription
            
        case .globalError(reason: let reason):
            return reason.localizedDescription
        }

    }
}

public extension ShrimpBaseError.NetworkErrorReason {
    public var localizedDescription: String {
        switch self {
        case .noNetwork:
            return "No Network"
        case .httpStatusCode(let error):
            return "http status code error:\n\(error.localizedDescription)"
        }
    }
}

public extension ShrimpBaseError.GlobaleErrorReason {
    public var localizedDescription: String {
        switch self {
        case .noData:
            return "No response data"
        case .dataSerialization(let error):
            return "data serialize error:\n\(error.localizedDescription)"
        }
    }
}
