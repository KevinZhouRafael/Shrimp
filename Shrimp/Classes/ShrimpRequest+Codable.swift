//
//  ShrimpRequest+Codeable.swift
//  Shrimp
//
//  Created by kai zhou on 27/01/2018.
//  Copyright © 2018 kai zhou. All rights reserved.
//

import Foundation


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static let iso8601noFS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601.date(from: string) ?? Formatter.iso8601noFS.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}


public extension ShrimpRequest{
    @discardableResult
    func responseCodable<T:Codable>(_ responseHandler:@escaping (_ result:T,_ response:URLResponse?)->Void,
                                           errorHandler:((_ error:Error?)->Void)?)->ShrimpRequest{

            return responseString({ (resultString, urlResponse) in
                
                let decoder = JSONDecoder()
                if #available(iOS 10.0, *) {
                    decoder.dateDecodingStrategy = .iso8601
                } else {
                    decoder.dateDecodingStrategy = .customISO8601
                }
//                decoder.keyDecodingStrategy = ShrimpConfigure.shared.keyDecodingStrategy
                do{
                    let responseResult = try decoder.decode(T.self, from: Data(resultString.utf8))
                    
                    responseHandler(responseResult,urlResponse)
                    
                }catch {
                    debugPrint("\(error)")
                    errorHandler?(ShrimpError.createError(ShrimpError.Code.responseDecodingFailed.rawValue, localizedDescription: "响应解析错误。\(error.localizedDescription)"))
                    
                }
                
            }, errorHandler:{(error) in
                errorHandler?(error)
                
            })

    }
    
    @discardableResult
    func responseCodable<T:Codable>(_ responseHandler:@escaping (_ result:T, _ data:Data?,_ response:URLResponse?)->Void,
                                           errorHandler:((_ error:Error?)->Void)?)->ShrimpRequest{

            return responseData({ (resultData, urlResponse) in
                
                let decoder = JSONDecoder()
                if #available(iOS 10.0, *) {
                    decoder.dateDecodingStrategy = .iso8601
                } else {
                    decoder.dateDecodingStrategy = .customISO8601
                }
//                decoder.keyDecodingStrategy = ShrimpConfigure.shared.keyDecodingStrategy
                do{
                    let resultString = String(data: resultData, encoding: String.Encoding.utf8)!
                    let responseResult = try decoder.decode(T.self, from: Data(resultString.utf8))
                    
                    responseHandler(responseResult,resultData,urlResponse)
                    
                }catch {
                    debugPrint("\(error)")
                    errorHandler?(ShrimpError.createError(ShrimpError.Code.responseDecodingFailed.rawValue, localizedDescription: "响应解析错误。\(error.localizedDescription)"))
                    
                }
                
            }, errorHandler:{(error) in
                errorHandler?(error)
                
            })

    }
}

