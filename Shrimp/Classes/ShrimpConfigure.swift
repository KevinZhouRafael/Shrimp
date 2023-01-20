//
//  Configure.swift
//  Shrimp
//
//  Created by yuhan on 29/09/2017.
//  Copyright © 2017 kai zhou. All rights reserved.
//

import Foundation

public protocol ShrimpConfigureDelegate:AnyObject {
    func urlToKey(url:String) -> String
    func defaultHeaders()->[String:String]
    func defaultQueryParams()->[String:Any]
}
public extension ShrimpConfigureDelegate{
    func urlToKey(url:String) -> String{
        return url
    }
    func defaultHeaders()->[String:String]{
        return [String:String]()
    }
    func defaultQueryParams()->[String:Any]{
        return [String:Any]()
    }
}

public class ShrimpConfigure {
    public static let shared:ShrimpConfigure = ShrimpConfigure()
    
    public weak var delegate:ShrimpConfigureDelegate?
    
    public var HOST:String = ""
    //    public var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    public var timeoutIntervalForRequest:Double = 60.0
    
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
    
    func defaultQueryParams()->[String:Any]{
        return delegate?.defaultQueryParams() ?? [String:Any]()
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
    
    //https://blog.mro.name/2009/08/nsdateformatter-http-header/
    static var gmt:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        return dateFormatter
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

//偏移量基本不变，因为服务器时间和systemUptime都在增加。
struct ServerDate{
    /// 获取当前时间
    ///
    /// - Returns: 如果有偏移时间，返回处理器启动时间 + 偏移时间。如果没有返回Date().timeIntervalSince1970
    static func now() -> TimeInterval{
        //TODO: userdefaults作为config的参数
        if let offsetStime = UserDefaults.standard.value(forKey: "Shrimp_Server_Offset_Time") as? TimeInterval{
            return offsetStime + ProcessInfo().systemUptime
        }else{
            return Date().timeIntervalSince1970
        }
    }
    
    /// 更新偏移时间(每次网络返回时调用)
    ///
    /// - Parameter stime: 服务器时间
    static func update(stime:TimeInterval?){
        if let stime = stime {
            let offsetStime = stime - ProcessInfo().systemUptime
            UserDefaults.standard.set(offsetStime, forKey: "Shrimp_Server_Offset_Time")
        }
    }
}

extension ServerDate{
    static func update(response:URLResponse?){
        if let httpResponse = response as? HTTPURLResponse,
           let dateHeader = httpResponse.allHeaderFields["Date"] as? String,
           let date = Formatter.gmt.date(from: dateHeader){
            
            let serverTime = date.timeIntervalSince1970
            var age:Int64 = 0
            
            if let ageHeader = httpResponse.allHeaderFields["Age"] as? String,
               let ageInt = Int64(ageHeader){
                age = ageInt
            }
            
            update(stime: serverTime + Double(age))
        }
    }
}

extension ShrimpConfigure{
    public static func serverTimeInterval() -> TimeInterval{
        ServerDate.now()
    }
}
