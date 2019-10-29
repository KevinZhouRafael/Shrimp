//
//  Configure.swift
//  Shrimp
//
//  Created by yuhan on 29/09/2017.
//  Copyright © 2017 kai zhou. All rights reserved.
//

import Foundation
public protocol URLToKeyProtocol:class {
    func urlToKey(url:String) -> String
}
public class ShrimpConfigure {
    public static let shared:ShrimpConfigure = ShrimpConfigure()
    
    public weak var delegate:URLToKeyProtocol?

    public var HOST:String = ""
    
    public func urlToKey(url:String) -> String {
        if delegate != nil{
            return delegate!.urlToKey(url: url)
        }else{
            return url
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

