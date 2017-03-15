# Shrimp

[![CI Status](http://img.shields.io/travis/rafael zhou/ShrimpHttp.svg?style=flat)](https://travis-ci.org/rafael zhou/ShrimpHttp)
[![Version](https://img.shields.io/cocoapods/v/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)
[![Platform](https://img.shields.io/cocoapods/p/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)


Shrimp is an simplify HTTP networking library written in Swift.

## Features

- [x] Chainable Request / Response Methods
- [x] Parameter Encoding
- [x] GET / POST / PUT / DELETE
- [x] Resume Download Datas
- [x] Download with Progress Notification
- [ ] Upload files
- [ ] Builtin JSON Request Serialization

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Usage

### GET

```swift
        ShrimpRequest().request(.GET, urlString: "https://httpbin.org/get")
        .responseString ({ (string, response) in
            debugPrint("GET: \(string)")
        })
```

### POST

```swift

        ShrimpRequest().request(.POST, urlString: "http://www.mocky.io/v2/56c5b7a80f0000d027a204e2", parameters: ["username":"rafael",
            "password":"123456"])
        .responseJSONObject({ (json, response) in
                debugPrint(json["first_name"])
                debugPrint(json["last_name"])
                debugPrint(json["gender"])            
            }, errorHandler: { (error) in
                
        })
```
### DOWNLOAD

#### Start Download
```swift
DownloadManager.download(withURL: downloadURLString, withDestPath: destPath)
```

#### Resume Download

```swift
DownloadManager.resumeDownload(withURL: downloadURLString, withDestPath: destPath)

```

#### Register Download Notifications

```swift
NotificationCenter.default.addObserver(self, selector: SELECTOR ), name: NSNotification.Name(rawValue: Noti_DownloadManager_Start), object: nil)
NotificationCenter.default.addObserver(self, selector: SELECTOR ), name: NSNotification.Name(rawValue: Noti_DownloadManager_Progress), object: nil)
NotificationCenter.default.addObserver(self, selector: SELECTOR ), name: NSNotification.Name(rawValue: Noti_DownloadManager_Complete), object: nil)
NotificationCenter.default.addObserver(self, selector: SELECTOR ), name: NSNotification.Name(rawValue: Noti_DownloadManager_Failed), object: nil)
NotificationCenter.default.addObserver(self, selector: SELECTOR ), name: NSNotification.Name(rawValue: Noti_DownloadManager_Cancel), object: nil)

```

#### Observe Notifications
```swift
func downloadProgress(noti:Notification) {
        let url = noti.userInfo!["url"] as! String
        let progress = noti.userInfo!["progress"] as! Float
        let bytesWritten = noti.userInfo!["bytesWritten"] as! Int64
        let totalBytesWritten = noti.userInfo!["totalBytesWritten"] as! Int64
        let totalBytesExpectedToWrite = noti.userInfo!["totalBytesExpectedToWrite"] as! Int64
        
        debugPrint("url:\(url),progress:\(progress),bytesWritten:\(bytesWritten),totalBytesWritten\(totalBytesWritten),totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)")
        
        //url:http://www.abc.com/xyz.zip, progress :0.6, bytesWritten :30, totalBytesWritten :6000, totalBytesExpectedToWrite :10000 
            
}


func downloadComplete(noti:Notification) {
    let url = noti.userInfo!["url"] as! String
    let destPath = noti.userInfo!["destPath"] as! String

}


```

#### Other Methods
```swift
    DownloadManager.pauseDownload(withURL url:String)
    DownloadManager.pauseDownloadAll()
    DownloadManager.isDownloading(url:String)    
    DownloadManager.isHasResumDate(url:String)

```

## Requirements
- iOS 8.0+  
- Xcode 7.3
- Swift 3.0.1

## Installation

###Cocoapods

Shrimp is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Shrimp"
```

###Carthage

If you're using Carthage you can add a dependency on ObjectMapper by adding it to your Cartfile:

```ruby
github "KevinChouRafael/Shrimp"
```

## Author

rafael zhou, wumingapie@gmail.com

## License

Shrimp is available under the MIT license. See the LICENSE file for more info.
