//
//  ShrimpRequest.swift
//  ShrimpHttp
//
//  Created by Rafael on 12/28/15.
//  Copyright © 2015 Rafael. All rights reserved.
//

import Foundation
public class ShrimpRequest {
    
    
    private var urlRequest:NSMutableURLRequest!
    private var config:NSURLSessionConfiguration!
    private var task:NSURLSessionDataTask!
    private var responseDataHandler:((data:NSData,response:NSURLResponse)->Void)?
    private var responseStringHandler:((string:String,response:NSURLResponse)->Void)?
    private var responseJSONObjectHandler:((json:AnyObject,response:NSURLResponse)->Void)?
    private var errorHandler:((error:NSError)->Void)?
    
    var contentType = ContentType.UrlEncoded
    
    var abc:Int!
    private var cba:Int!
    public var aaa:Int!
    
    public init(){
        
    }
    
    public func request(
                method: Method,
                urlString: String,
                parameters: [String: AnyObject]? = nil,
                headers: [String: String]? = nil)
        -> ShrimpRequest
    {
        
        
        buildURL(method, urlString: urlString,parameters: parameters)
        buildHeader(method, headers: headers)
        buildParameters(method, parameters: parameters)
        
        return self
    }
    
    private func buildURL(method:Method,urlString:String,parameters: [String: AnyObject]? = nil){

        var requestURL:NSURL = NSURL(string:"\(urlString)")!
        
        switch method {
        case .GET:
            requestURL = NSURL(string:"\(urlString)?\(parameters?.stringFromHttpParameters())")!
            break
        case .POST, .PUT, .DELETE:
            
            break
            
        }
        
        urlRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest!.HTTPMethod = method.rawValue
    }
    
    private func buildHeader(method:Method,headers: [String: String]? = nil){
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
        
        config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config!.HTTPAdditionalHeaders = headerDic
    }
    
    
    private func buildParameters(method:Method,parameters:[String: AnyObject]? = nil){
        switch method {
        case .GET:
            break
        case .POST, .PUT, .DELETE:
            if parameters != nil {
                
                switch contentType {
                case .UrlEncoded:
                    let queryString = query(parameters!)
                    
                    urlRequest.HTTPBody = queryString.dataUsingEncoding(NSUTF8StringEncoding)
                    break;
                    
                case .JSON:
                    do{
                        let data = try NSJSONSerialization.dataWithJSONObject(parameters!, options: .PrettyPrinted)
                        urlRequest.HTTPBody = data
                        
                    }catch{
                        
                    }
                    break;
                    
                }


            }
            break
            
        }

        
    }
    public func responseData(responseHandler:(data:NSData,response:NSURLResponse)->Void,errorHandler:((error:NSError)->Void)? = nil)->ShrimpRequest{
        
        self.responseDataHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }

    public func responseString(responseHandler:(string:String,response:NSURLResponse)->Void,errorHandler:((error:NSError)->Void)? = nil)->ShrimpRequest{
        
        self.responseStringHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    public func responseJSONObject(responseHandler:(json:AnyObject,response:NSURLResponse)->Void,errorHandler:((error:NSError)->Void)? = nil)->ShrimpRequest{
        
        self.responseJSONObjectHandler = responseHandler
        self.errorHandler = errorHandler
        
        requestNetWork()
        
        return self
    }
    
    
    private func requestNetWork(){
        let session = NSURLSession(configuration: config)
        
        task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
            
            if error == nil{
                let httpResponse = response as! NSHTTPURLResponse
                let code = httpResponse.statusCode
                
                let acceptableStatusCodes: Range<Int> = 200..<300
                if acceptableStatusCodes.contains(httpResponse.statusCode) {
                    
                    let resultString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    
                    debugPrint("***ShrimpRequest-- Request URL --> \( response!.URL!.absoluteString) \n Result -> \(resultString)")
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.responseDataHandler != nil {
                            self.responseDataHandler!(data: data!,response:response!)
                        }else if self.responseStringHandler != nil {
                            self.responseStringHandler!(string:resultString,response:response!)
                        }else if self.responseJSONObjectHandler != nil {
                            do {
                                let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                                self.responseJSONObjectHandler!(json:object,response:response!)
                                
                            } catch _ as NSError {
                                if self.errorHandler != nil {
                                    self.errorHandler!(error: ShrimpError.createError(code,localizedDescription: "JSON serialization error"))
                                }
                            }
                            
                        }
                        
                    }

                    
                } else {
                        
                        let httpResponse = response as! NSHTTPURLResponse
                        let code = httpResponse.statusCode
                        let msg = httpResponse.allHeaderFields["Status"]?.string
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if self.errorHandler != nil {
                                self.errorHandler!(error: ShrimpError.createError(code,localizedDescription: msg))
                            }
                        }

                }
                    
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    if self.errorHandler != nil {
                        self.errorHandler!(error: error!)
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

    func query(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sort(<) {
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
    }
    
    public func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    public func escape(string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        let allowedCharacterSet = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
        allowedCharacterSet.removeCharactersInString(generalDelimitersToEncode + subDelimitersToEncode)
        
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
        
        if #available(iOS 8.3, OSX 10.10, *) {
            escaped = string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = index.advancedBy(batchSize, limit: string.endIndex)
                let range = startIndex..<endIndex
                
                let substring = string.substringWithRange(range)
                
                escaped += substring.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }

}