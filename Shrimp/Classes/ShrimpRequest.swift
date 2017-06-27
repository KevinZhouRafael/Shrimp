//
//  ShrimpRequest.swift
//  ShrimpHttp
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
    fileprivate var errorHandler:((_ error:Error)->Void)?
    
    var contentType = ContentType.UrlEncoded
    
    
    public init(){
        
    }
    
    open func request(
                _ method: Method,
                urlString: String,
                parameters: [String: Any]? = nil,
                headers: [String: String]? = nil)
        -> ShrimpRequest
    {
        
        
        buildURL(method, urlString: urlString,parameters: parameters)
        buildHeader(method, headers: headers)
        buildParameters(method, parameters: parameters)
        
        return self
    }
    
    fileprivate func buildURL(_ method:Method,urlString:String,parameters: [String: Any]? = nil){

        var requestURL:URL = URL(string:"\(urlString)")!
        
        if parameters != nil {
            switch method {
            case .GET:
                requestURL = URL(string:"\(urlString)?\(query(parameters!))")!

                break
            case .POST, .PUT, .DELETE:
                
                break
            }
        }
        
        urlRequest = NSMutableURLRequest(url: requestURL)
        urlRequest!.httpMethod = method.rawValue
    }
    
    fileprivate func buildHeader(_ method:Method,headers: [String: String]? = nil){
        //header
        var headerDic = [String:String]()

        switch method {
        case .GET:
            break
        case .POST, .PUT, .DELETE:
            break
            
        }
        
        headerDic["Content-Type"] = contentType.rawValue
        
        
        if headers != nil {
            for (key,value) in headers! {
                headerDic[key] = value
            }
        }
        
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
                    
                }


            }
            break
            
        }

        
    }
    public func responseData(_ responseHandler:@escaping (_ data:Data,_ response:URLResponse)->Void,errorHandler:(@escaping (_ error:Error)->Void))->ShrimpRequest{
        
        self.responseDataHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    public func responseData(_ responseHandler:@escaping (_ data:Data,_ response:URLResponse)->Void,errorHandler:((_ error:Error)->Void)? = nil)->ShrimpRequest{
        
        self.responseDataHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }

    public func responseString(_ responseHandler:@escaping (_ string:String,_ response:URLResponse)->Void,errorHandler:@escaping (_ error:Error)->Void)->ShrimpRequest{
        
        self.responseStringHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    public func responseJSONObject(_ responseHandler:@escaping (_ json:Any,_ response:URLResponse)->Void,errorHandler:@escaping (_ error:Error)->Void)->ShrimpRequest{
        
        self.responseJSONObjectHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    
    fileprivate func requestNetWork(){
        let session = URLSession(configuration: config)
        
        task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
            

            
            if error == nil{
                let httpResponse = response as! HTTPURLResponse
                let code = httpResponse.statusCode
                
                let acceptableStatusCodes: CountableRange<Int> = 200..<300
                if acceptableStatusCodes.contains(httpResponse.statusCode) {
                    
                    
                    let resultString = String(data: data!, encoding: String.Encoding.utf8)
                    

                    debugPrint("***ShrimpRequest-- Request URL --> \( response!.url!.absoluteString) \n Error -> \(error?.localizedDescription) \n Result -> \(resultString)")
                    
                    DispatchQueue.main.async {
                        if self.responseDataHandler != nil {
                            self.responseDataHandler!(data!,response!)
                        }else if self.responseStringHandler != nil {
                            self.responseStringHandler!(resultString!,response!)
                        }else if self.responseJSONObjectHandler != nil {
                            do {
                                let object: Any = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                                self.responseJSONObjectHandler!(object,response!)
                                
                            } catch {
                                if self.errorHandler != nil {
                                    self.errorHandler!(ShrimpError.createError(code,localizedDescription: "JSON serialization error"))
                                }
                            }
                            
                        }
                        
                    }

                    
                } else {
                    
                    let httpResponse = response as! HTTPURLResponse
                    let code = httpResponse.statusCode
                    
                    debugPrint("***ShrimpRequest-- Request URL --> \( response!.url!.absoluteString) \n ErrorCode -> \(code) \n")
                    
                    //TODO 错误处理
                    if let msg = httpResponse.allHeaderFields["Status"] as? String{
                        DispatchQueue.main.async {
                            
                            if self.errorHandler != nil {
                                self.errorHandler!(ShrimpError.createError(code,localizedDescription: msg))
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            
                            if self.errorHandler != nil {
                                self.errorHandler!(ShrimpError.createError(code,localizedDescription: ""))
                            }
                        }
                    }
                        
                    

                }
                    
            }else{
                debugPrint("***ShrimpRequest-- Request URL --> \(response?.url?.absoluteString) \n Error -> \(error?.localizedDescription) \n")
                
                DispatchQueue.main.async {
                    if self.errorHandler != nil {
                        self.errorHandler!(error!)
                    }
                }
                
                //                if error!.domain == NSURLErrorDomain && error!.code == NSURLErrorNotConnectedToInternet {
                //
                //                    dispatch_async(dispatch_get_main_queue()) {
                //                        if self.errorHandler != nil {
                //                            self.errorHandler!(error: error!)
                //                        }
                //                    }
                //                }else{
                //
                //                    dispatch_async(dispatch_get_main_queue()) {
                //                        if self.errorHandler != nil {
                //                            self.errorHandler!(error: error!)
                //                        }
                //                    }
                //                }
                
            }
            
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


