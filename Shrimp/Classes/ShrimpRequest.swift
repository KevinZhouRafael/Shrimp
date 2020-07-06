//
//  ShrimpRequest.swift
//  Shrimp
//
//  Created by Rafael on 12/28/15.
//  Copyright © 2015 Rafael. All rights reserved.
//

import Foundation
open class ShrimpRequest {
    
    fileprivate var urlRequest:NSMutableURLRequest!
    fileprivate var config:URLSessionConfiguration!
    fileprivate var task:URLSessionDataTask!
    fileprivate var responseDataHandler:((_ data:Data,_ response:URLResponse)->Void)?
    fileprivate var responseStringHandler:((_ string:String,_ response:URLResponse)->Void)?
    fileprivate var responseJSONObjectHandler:((_ json:Any,_ response:URLResponse)->Void)?
    fileprivate var errorHandler:((_ error:Error?)->Void)?
    
    //Saved ContentType:  ContentType parameters > headers params > defaultContentType
    fileprivate var contentType:ContentType!
    
    
    public init(){
        
    }
    
//    open func defaultHeaders() ->[String:String]{
//        return [String:String]()
//    }
    open func request(
                _ method: Method,
                api: ShrimpNetApi,
                contentType:ContentType? = nil,
                parameters: [String: Any]? = nil,
                headers: [String: String]? = nil)
        -> ShrimpRequest
    {
        buildURL(method, urlString: api.path,parameters: parameters)
        buildHeader(method, headers: headers,contentType: contentType)
        buildParameters(method, parameters: parameters)
        
        return self
    }
    
    open func request(
                _ method: Method,
                urlString: String,
                contentType:ContentType? = nil,
                parameters: [String: Any]? = nil,
                headers: [String: String]? = nil)
        -> ShrimpRequest
    {
        buildURL(method, urlString: urlString,parameters: parameters)
        buildHeader(method, headers: headers,contentType: contentType)
        buildParameters(method, parameters: parameters)
        
        return self
    }
    
    fileprivate func buildURL(_ method:Method,urlString:String,parameters: [String: Any]? = nil){

        var requestURL:URL = URL(string:"\(urlString)")!
        
        if parameters != nil {
            switch method {
            case .GET:
//                requestURL = URL(string:"\(urlString)?\(query(parameters!))")!s

                var components = URLComponents(string: urlString)!
                components.queryItems = [URLQueryItem]()
                for (key, value) in parameters ?? [:] {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    components.queryItems!.append(queryItem)
                }
                
                components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                
                requestURL = components.url!
                
                break
            case .POST, .PUT, .DELETE:
                
                break
            }
        }
        
        urlRequest = NSMutableURLRequest(url: requestURL)
        urlRequest!.httpMethod = method.rawValue
    }
    
    fileprivate func buildHeader(_ method:Method,headers: [String: String]? = nil,contentType:ContentType? = nil){
        //header
        var headerDic = ShrimpConfigure.shared.defaultHeaders()

        switch method {
        case .GET:
            headerDic["Content-Type"] = ShrimpConfigure.shared.DefaultGetContentType.rawValue
            break
        case .POST, .PUT, .DELETE:
            headerDic["Content-Type"] = ShrimpConfigure.shared.DefaultPostContentType.rawValue
            break
            
        }
        
        if headers != nil {
            for (key,value) in headers! {
                headerDic[key] = value
            }
        }
        
        if let ctype = contentType{
            headerDic["Content-Type"] = ctype.rawValue
        }
        
        self.contentType = ContentType(rawValue: headerDic["Content-Type"]!)!
        config = URLSessionConfiguration.default
        config!.httpAdditionalHeaders = headerDic
    }
    
    
    fileprivate func buildParameters(_ method:Method,parameters:[String: Any]? = nil){
        switch method {
        case .GET:
            break
        case .POST, .PUT, .DELETE:
            if parameters != nil {
                
                switch contentType {
                case .UrlEncoded:
                    let queryString = query(parameters!)
                    
                    urlRequest.httpBody = queryString.data(using: String.Encoding.utf8)
                    break;
                    
                case .JSON:
                    do{
                        let data = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                        urlRequest.httpBody = data
                        
                    }catch{
                        
                    }
                    break;
                    
                case .none:
                    assertionFailure("Content-Type Error.")
                    break
                    
                }


            }
            break
            
        }

        
    }
    
    @discardableResult
    public func responseData(_ responseHandler:@escaping (_ data:Data,_ response:URLResponse?)->Void,errorHandler:(@escaping (_ error:Error?)->Void))->ShrimpRequest{
        
        self.responseDataHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    @discardableResult
    public func responseData(_ responseHandler:@escaping (_ data:Data?,_ response:URLResponse?)->Void,errorHandler:((_ error:Error?)->Void)? = nil)->ShrimpRequest{
        
        self.responseDataHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }

    @discardableResult
    public func responseString(_ responseHandler:@escaping (_ string:String,_ response:URLResponse?)->Void,errorHandler:@escaping (_ error:Error?)->Void)->ShrimpRequest{
        
        self.responseStringHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    @discardableResult
    public func responseJSONObject(_ responseHandler:@escaping (_ json:Any,_ response:URLResponse?)->Void,errorHandler:@escaping (_ error:Error?)->Void)->ShrimpRequest{
        
        self.responseJSONObjectHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    
    fileprivate func requestNetWork(){
        let session = URLSession(configuration: config)
        
        task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            
            //guard error
            //guard data,response
            guard error == nil else{
                debugPrint("***ShrimpRequest-- Request URL --> \(String(describing: response?.url?.absoluteString)) \n Error -> \(error!.localizedDescription) \n")
                DispatchQueue.main.async {
                    self.errorHandler?(error)
                }
                return
            }
            
            guard let data = data, let response = response, let httpResponse = response as? HTTPURLResponse else{
                
                debugPrint("***ShrimpRequest-- no response and data. \n")
                DispatchQueue.main.async {
                    self.errorHandler?(error)
                }
                return
            }
            
            let code = httpResponse.statusCode
            let resultString = String(data: data, encoding: String.Encoding.utf8)
                
//            let acceptableStatusCodes: CountableRange<Int> = 200..<300
//            if acceptableStatusCodes.contains(httpResponse.statusCode) {
                
                debugPrint("***ShrimpRequest-- Request URL --> \( String(describing: httpResponse.url?.absoluteString)) \n StatusCode -> \(code)，Result -> \(String(describing: resultString))")
                    
                DispatchQueue.main.async {
                    if self.responseDataHandler != nil {
                        self.responseDataHandler!(data,response)
                    }else if self.responseStringHandler != nil {
                        self.responseStringHandler!(resultString ?? "",response)
                    }else if self.responseJSONObjectHandler != nil {
                        do {
                            let object: Any = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            self.responseJSONObjectHandler!(object,response)
                            
                        } catch {
                            debugPrint("***ShrimpRequet-- Error -> ß\(error)")
                            self.errorHandler?(NSError(httpStatusCode: code,localizedDescription: "JSON serialization error"))
                        }
                        
                    }
                    
                }

                //狀態碼錯誤
//            } else {
//                debugPrint("***ShrimpRequest-- Request URL --> \( httpResponse.url?.absoluteString) \n data -> \(resultString) \n ErrorCode -> \(code) \n")
//
//                if let msg = resultString {
//                    DispatchQueue.main.async {
//                        self.errorHandler?(ShrimpError.createError(code,localizedDescription: msg))
//                    }
//                }else if let msg = httpResponse.allHeaderFields["Status"] as? String{
//                    DispatchQueue.main.async {
//                        self.errorHandler?(ShrimpError.createError(code,localizedDescription: msg))
//                    }
//                }else{
//                    DispatchQueue.main.async {
//                        self.errorHandler?(ShrimpError.createError(code))
//                    }
//                }
//            }
            
            
        })
        
        
        if task != nil {
            task!.resume()
        }
    }

    
    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }


}


//MARK: Utils

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
        
        return parameterArray.joined(separator: "&")
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
        
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}

extension NSNumber {
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}

//extension String{
//    //from wei wang
//    var MD5: String {
//        let cString = self.cString(using: String.Encoding.utf8)
//        let length = CUnsignedInt(
//            self.lengthOfBytes(using: String.Encoding.utf8)
//        )
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(
//            capacity: Int(CC_MD5_DIGEST_LENGTH)
//        )
//
//        CC_MD5(cString!, length, result)
//
//        return String(format:
//            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                      result[0], result[1], result[2], result[3],
//                      result[4], result[5], result[6], result[7],
//                      result[8], result[9], result[10], result[11],
//                      result[12], result[13], result[14], result[15])
//    }
//
//    func md5() -> String {
//
//        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
//        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
//        CC_MD5_Init(context)
//        CC_MD5_Update(context, self, CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8)))
//        CC_MD5_Final(&digest, context)
//        context.deallocate(capacity: 1)
//        var hexString = ""
//        for byte in digest {
//            hexString += String(format:"%02x", byte)
//        }
//
//        return hexString
//    }
//
//}
