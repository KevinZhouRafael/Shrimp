//
//  ShrimpRequest+Codeable.swift
//  Shrimp
//
//  Created by kai zhou on 27/01/2018.
//  Copyright © 2018 kai zhou. All rights reserved.
//

import Foundation


public extension ShrimpRequest{
    @discardableResult
    func responseCodable<T:Decodable>(_ responseHandler:@escaping (_ result:T,_ response:URLResponse?)->Void,
                                           errorHandler:((_ error:Error?)->Void)?)->ShrimpRequest{

            return responseString({ (resultString, urlResponse) in
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = ShrimpConfigure.shared.dateDecodingStrategy
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
    func responseCodable<T:Decodable>(_ responseHandler:@escaping (_ result:T, _ data:Data?,_ response:URLResponse?)->Void,
                                           errorHandler:((_ error:Error?)->Void)?)->ShrimpRequest{

            return responseData({ (resultData, urlResponse) in
                
                guard resultData.count > 0 else{
                    if let httpResponse = urlResponse as? HTTPURLResponse{
                        let code = httpResponse.statusCode
                        debugPrint("\(code)")
                        errorHandler?(ShrimpError.createError(code))
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = ShrimpConfigure.shared.dateDecodingStrategy
                
                do{
//                    let resultString = String(data: resultData, encoding: String.Encoding.utf8)!
//                    let responseResult = try decoder.decode(T.self, from: Data(resultString.utf8))
                    let responseResult = try decoder.decode(T.self, from: resultData)
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

