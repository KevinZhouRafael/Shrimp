# ShrimpHttp

[![CI Status](http://img.shields.io/travis/rafael zhou/ShrimpHttp.svg?style=flat)](https://travis-ci.org/rafael zhou/ShrimpHttp)
[![Version](https://img.shields.io/cocoapods/v/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)
[![License](https://img.shields.io/cocoapods/l/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)
[![Platform](https://img.shields.io/cocoapods/p/ShrimpHttp.svg?style=flat)](http://cocoapods.org/pods/ShrimpHttp)

ShrimpHttp is an simplify HTTP networking library written in Swift.

## Features

- [x] Chainable Request / Response Methods
- [x] Parameter Encoding
- [x] GET / POST / PUT / DELETE
- [ ] Builtin JSON Request Serialization
- [ ] NSOperationQueue Support
- [ ] Download File using Request or Resume Data
- [ ] Upload/Download with Progress Closure


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

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

## Requirements
- iOS 8.0+  
- Xcode 7.3
- Swift 2.2

## Installation

ShrimpHttp is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ShrimpHttp"
```

## Author

rafael zhou, wumingapie@gmail.com

## License

ShrimpHttp is available under the MIT license. See the LICENSE file for more info.
