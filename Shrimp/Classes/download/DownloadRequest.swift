//
//  DownloadRequest.swift
//  sheer
//
//  Created by kai zhou on 07/12/2016.
//  Copyright © 2016 kevin. All rights reserved.
//

import UIKit


public class DownloadRequest:NSObject,URLSessionDownloadDelegate {

    lazy var session:URLSession = {
        let configuration = URLSessionConfiguration.default
        let sessionItem = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return sessionItem
    }()
    
    var downloadTask:URLSessionDownloadTask!
    var resumeData:Data?
    
    var url:String = ""
    var destPath = ""
    var resumeDataPath = ""
    
    
    public func download(url:String,destPath:String) {
        self.url = url
        self.destPath = destPath

        if FileManager.checkDic(withPath: self.destPath){}
        
        resumeDownload(url: url, destPath: destPath)
    }
    
    public func pauseDownload(){
        if downloadTask == nil {
            return
        }
        downloadTask.cancel { (data) in
            self.resumeData = data
            
            self.downloadCancel()
            
            
        }
        
    }
    
    
    public func resumeDownload(url:String,destPath:String){
        
        //find resumeData
        do{
            self.url = url
            self.destPath = destPath
            let resumeDataPath = getResumtDataPath(url: url)
            
            if FileManager.default.fileExists (atPath: resumeDataPath) {
                try resumeData = Data(contentsOf: URL(fileURLWithPath:resumeDataPath))
            }

        }catch let e {
            debugPrint(e)
        }
        
        //start resume
        if resumeData != nil {
            downloadTask = session.downloadTask(withResumeData: resumeData!)
            downloadTask.resume()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Noti_DownloadManager_Start), object: nil, userInfo: ["url":self.url])
            }
            
        //start new download
        }else{
            startDownload()
        }
        
    }
    

    
    private func startDownload(){
        
        let request = URLRequest(url: URL(string: self.url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 3600)
        downloadTask = session.downloadTask(with:request)
        downloadTask.resume()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Noti_DownloadManager_Start), object: nil, userInfo: ["url":self.url])
        }
    }
    
    //param mark URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        debugPrint("fileOffset:\(fileOffset),expectedTotalBytes\(expectedTotalBytes)")
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
//        debugPrint("任务id=\(downloadTask.taskIdentifier) - operationCount=\(DownloadManager.queue.operationCount) maxConcurrentOperationCount=\(DownloadManager.queue.maxConcurrentOperationCount)-----bytesWritten:\(bytesWritten),totalBytesWritten\(totalBytesWritten),totalBytesExpectedToWrite\(totalBytesExpectedToWrite)")
        
        let s = String(format: "-->>taskURL=%@ \n    perSecond:%lld, downloaded%lld, total%lld， %0.2f%%",url,bytesWritten,totalBytesWritten,totalBytesExpectedToWrite, Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)*100.0)
       debugPrint(s)
        
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:Noti_DownloadManager_Progress),
                                    object: nil,
                                    userInfo: ["url":self.url,
                                               "progress":Float(Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)),"bytesWritten":bytesWritten,
                                               "totalBytesWritten":totalBytesWritten,
                                               "totalBytesExpectedToWrite":totalBytesExpectedToWrite]
                            )
        }
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //file:///private/var/mobile/Containers/Data/Application/E3E8AA28-C2E0-45AD-A1A7-DB930A2C4971/tmp/CFNetworkDownload_957ZCB.tmp
        debugPrint("location:\(location)")
        
        
        do {
            
            if(FileManager.default.fileExists(atPath: self.destPath)){
                try FileManager.default.removeItem(atPath: self.destPath)
            }
            try FileManager.default.moveItem(atPath: location.path, toPath: self.destPath)
            
            removeResumeData(url: self.url)
            
            self.downloadTask = nil
            DownloadManager.requestDic[url] = nil
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Noti_DownloadManager_Complete), object: nil, userInfo: ["url":self.url,"destPath":self.destPath])
            }
            
            
        }catch let error as NSError{
            print("Something went wrong\(error)")
            
            downloadFaild()

        }
    
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        //after cancel
        if let nserror = error as? NSError {
            
            debugPrint("error:\(String(describing: error))")
            
            if nserror.code == -999 && nserror.localizedDescription == "cancelled" {
                
                if let data = nserror.userInfo[NSURLSessionDownloadTaskResumeData] as? Data{
                    self.resumeData = data
                   downloadCancel()
                }
            }else{
                downloadFaild()
            }
            
        }else{
            
        }
        
    }
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("error:\(String(describing: error))")
    }
    
    private func downloadCancel(){
        if saveResumeData(url:self.url,resumeData: self.resumeData) {}
        
        self.downloadTask = nil
        DownloadManager.requestDic[url] = nil
    }
    
    private func downloadFaild(){
        
        removeResumeData(url: self.url)
        
        self.downloadTask = nil
        DownloadManager.requestDic[url] = nil
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Noti_DownloadManager_Failed), object: nil, userInfo: ["url":self.url,"message":"download falis"])
        }
        
    }
    
}
