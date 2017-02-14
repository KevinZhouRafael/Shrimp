//
//  DownloadManager.swift
//  shrimp
//
//  Created by kai zhou on 06/12/2016.
//  Copyright © 2016 kevin. All rights reserved.
//

import UIKit

public let Noti_DownloadManager_Start  = "Noti_DownloadManager_Start"
public let Noti_DownloadManager_Complete  = "Noti_DownloadManager_Complete"
public let Noti_DownloadManager_Failed  = "Noti_DownloadManager_Failed"
public let Noti_DownloadManager_Cancel = "Noti_DownloadManager_Cancel"
public let Noti_DownloadManager_Progress  = "Noti_DownloadManager_Progress"

public class DownloadManager:NSObject {
    
//    static let shared:DownloadManager = DownloadManager()
    
    private static let queue:OperationQueue = OperationQueue()
    static var requestDic:Dictionary<String,DownloadRequest> = Dictionary<String,DownloadRequest>()
    

    public class func download(withURL url:String,withDestPath destPath:String) {
        
        let downloadRequest = DownloadRequest()
        downloadRequest.download(url: url, destPath: destPath)
        requestDic[url] = downloadRequest
        
    }
    
    public class func resumeDownload(withURL url:String,withDestPath destPath:String){
        
        var downloadRequest = requestDic[url]
        if downloadRequest == nil {
            downloadRequest = DownloadRequest()
        }
        
        downloadRequest?.resumeDownload(url:url,destPath:destPath)
        requestDic[url] = downloadRequest
    }
    
    public class func pauseDownload(withURL url:String){
        if let downloadRequest = requestDic[url] {
            downloadRequest.pauseDownload()
        }
    }
    
    
    public class func pauseDownloadAll(){
        for( _,request )in requestDic {
            request.pauseDownload()
        }
    }
    
    public class func isDownloading(url:String)->Bool{

        for (key,request) in requestDic {
            if key == url && (request.downloadTask.state == .running || request.downloadTask.state == .suspended) {
                return true
            }
        }
        return false
    }
    
    public class func isHasResumDate(url:String)->Bool{
        return hasResumeDataPath(url: url)
    }
    
}


