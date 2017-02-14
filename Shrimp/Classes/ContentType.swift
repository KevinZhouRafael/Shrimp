//
//  ContentType.swift
//  ShrimpHttp
//
//  Created by rafael on 7/18/16.
//  Copyright © 2016 Rafael. All rights reserved.
//

import Foundation
import CryptoSwift

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

//resumeData相关操作

func getResumtDataPath(url:String)->String{

    //supportPath
    let supportURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

    let urlMD5 = url.md5()
    
    //dataPath
    let dataURL = supportURL.appendingPathComponent(urlMD5, isDirectory: false)
    
    return dataURL.path
    
}
 func hasResumeDataPath(url:String)->Bool{
    return FileManager.default.fileExists(atPath: getResumtDataPath(url:url))
}

func removeResumeData(url:String){

    let dataPath = getResumtDataPath(url: url)
    if FileManager.default.fileExists(atPath: dataPath){
        do{
            try FileManager.default.removeItem(atPath: dataPath)
        }catch{
            
        }
    }
}

func saveResumeData(url:String,resumeData:Data?)->Bool{
    guard resumeData != nil else {
        return false
    }
    let resumeDataPath = getResumtDataPath(url: url)
    let resumeDataURL = URL(fileURLWithPath:resumeDataPath)
    
    do{

        try resumeData!.write(to: resumeDataURL, options: .atomic)
        
        return true
    }catch let e {
        debugPrint(e)
        return false
    }
}

extension FileManager {
    
    static func checkDic(withPath dicPath:String) -> Bool {
        var isDir:ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: dicPath, isDirectory: &isDir)
        if exists && isDir.boolValue {
            return true
        }else{
            do{
                try FileManager.default.createDirectory(at:URL(fileURLWithPath: dicPath, isDirectory: true), withIntermediateDirectories: true, attributes: nil)
            }catch{
                return false
            }
            return true
        }
    }
    
    static func checkFile(withPath filePath:String){
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
    }
}
