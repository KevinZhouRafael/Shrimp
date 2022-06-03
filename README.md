# Shrimp

[![Version](https://img.shields.io/cocoapods/v/Shrimp.svg?style=flat)](http://cocoapods.org/pods/Shrimp)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Shrimp.svg?style=flat)](http://cocoapods.org/pods/Shrimp)
[![Platform](https://img.shields.io/cocoapods/p/Shrimp.svg?style=flat)](http://cocoapods.org/pods/Shrimp)


Shrimp is an simplify HTTP networking library written in Swift.

## Features

- [x] Chainable Request / Response Methods
- [x] Parameter Encoding
- [x] GET / POST / PUT / DELETE
- [x] Builtin JSON Request Serialization
- [x] Resume Download Datas
- [x] Download with Progress Notification
- [x] Auto Adjust Server Date


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## Usage

### GET

```swift
        Shrimp.request(.GET, urlString: "https://httpbin.org/get")
        .responseString ({ (string, response) in
            debugPrint("GET: \(string)")
        })
```

### POST

```swift

        Shrimp.request(.POST, urlString: "http://www.mocky.io/v2/56c5b7a80f0000d027a204e2", parameters: ["username":"rafael",
            "password":"123456"])
        .responseJSONObject({ (json, response) in
                debugPrint(json["first_name"])
                debugPrint(json["last_name"])
                debugPrint(json["gender"])            
            }, errorHandler: { (error) in
                
        })
```

### Get Server Time
Shrimp can auto adjust server time.
Get server time like this:

```swift
extension Date{
    static func serverNow()->Date{
        Date(ShrimpConfigure.serverTimeInterval())
    }
}

Date.serverNow()

```

### DOWNLOAD
More powerfull tools use [Reed Download](https://github.com/KevinZhouRafael/Reed).

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
- Xcode 11.3
- Swift 5

## Installation

### Cocoapods

Shrimp is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# swift5+ ,ios 8.0+
pod "Shrimp"
```

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage), you can add a dependency on Shrimp by adding it to your Cartfile:

```ruby
github "KevinZhouRafael/Shrimp"
```

## Author

Rafael Zhou

- Email me: <wumingapie@gmail.com>

## License

Shrimp is available under the MIT license. See the LICENSE file for more info.
