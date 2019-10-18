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
    func responseCodable<T:Codable>(_ responseHandler:@escaping (_ result:T,_ response:URLResponse)->Void,
                                           errorHandler:((_ error:Error)->Void)?)->ShrimpRequest{

            return responseString({ (resultString, urlResponse) in
                
                let decoder = JSONDecoder()
                do{
                    let responseResult = try decoder.decode(T.self, from: resultString.data(using: .utf8)!)
                    
                    responseHandler(responseResult,urlResponse)
                    
                }catch {
                    errorHandler?(ShrimpError.createError(ShrimpError.Code.responseDecodingFailed.rawValue, localizedDescription: "相应解析错误"))
                    
                }
                
            }, errorHandler:{(error) in
                errorHandler?(error)
                
            })

    }
}
