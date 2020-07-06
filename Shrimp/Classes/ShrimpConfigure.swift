//
//  Configure.swift
//  Shrimp
//
//  Created by yuhan on 29/09/2017.
//  Copyright © 2017 kai zhou. All rights reserved.
//

import Foundation
public protocol ShrimpConfigureDelegate:class {
    func urlToKey(url:String) -> String
    func defaultHeaders()->[String:String]
}
public extension ShrimpConfigureDelegate{
    func urlToKey(url:String) -> String{
        return url
    }
    func defaultHeaders()->[String:String]{
        return [String:String]()
    }
}

public class ShrimpConfigure {
    public static let shared:ShrimpConfigure = ShrimpConfigure()
    
    public weak var delegate:ShrimpConfigureDelegate?

    public var HOST:String = ""
//    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    
    public var DefaultGetContentType = ContentType.UrlEncoded
    public var DefaultPostContentType = ContentType.JSON
    
    private init(){
        
    }
    public func urlToKey(url:String) -> String {
        return delegate?.urlToKey(url: url) ?? url
    }
    func defaultHeaders()->[String:String]{
        return delegate?.defaultHeaders() ?? [String:String]()
    }
    
    var dateDecodingStrategy:JSONDecoder.DateDecodingStrategy{
        if #available(iOS 10.0, *) {
            return .iso8601
        } else {
            return .customISO8601
        }
    }
}


public class ShrimpNetURL{
    //eg:
    //let LOGIN:KCNetApi = "/api/account/login"
}

open class ShrimpNetApi:NSObject,ExpressibleByStringLiteral{
    
    let api: String
    
    public typealias StringLiteralType = String
    required public init(stringLiteral value: ShrimpNetApi.StringLiteralType) {
        self.api = value
    }

    public var path: String{
        return HOST + api
    }

    open var HOST:String{
        return ShrimpConfigure.shared.HOST
    }
    
}


extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    static let iso8601noFS: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
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

