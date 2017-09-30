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

    public func urlToKey(url:String) -> String {
        if delegate != nil{
            return delegate!.urlToKey(url: url)
        }else{
            return url
        }
    }
}

