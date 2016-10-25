//
//  ContentType.swift
//  ShrimpHttp
//
//  Created by rafael on 7/18/16.
//  Copyright © 2016 Rafael. All rights reserved.
//

import Foundation

public enum Method: String {
    case GET, POST, PUT, DELETE
}

public enum ContentType: String{
    case UrlEncoded = "application/x-www-form-urlencoded; charset=utf-8"

    case JSON = "application/json; charset=utf-8"
    
    //    case MultiPartFromData : "",
}


//let boundary = "Boundary+\(arc4random())\(arc4random())"
//headerDic["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
//
//
//let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
//headerDic["Content-Type"] = "application/x-www-form-urlencoded; charset=\(charset)"


extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joinWithSeparator("&")
    }
    
}

extension String{
    //urlstring
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.
    
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        //        let allowedCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        //        return self.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
}