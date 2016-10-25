import UIKit
import XCTest
import ShrimpHttp
import SwiftyJSON


class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testsGet(){
//        
//        let expectation = expectationWithDescription("testGetRequest")
//        ShrimpRequest().request(.GET, urlString: "https://httpbin.org/get").responseString({ (string, response) in
//            
//            debugPrint("GET: \(string)")
//            XCTAssert(true, "Pass")
//            expectation.fulfill()
//            
//            }, errorHandler: { (error) in
//                XCTAssert(false, "Failure")
//        })
//        
//        waitForExpectationsWithTimeout(30, handler: nil)
//    }
//    
//    func testsPost(){
//        let expectation = expectationWithDescription("testPostRequest")
//        
//        let params = [
//            "username":"rafael",
//            "password":"123456"]
//        
//        ShrimpRequest().request(.POST, urlString: "http://www.mocky.io/v2/56c5b7a80f0000d027a204e2", parameters: params).responseJSON({ (json, response) in
//            debugPrint(json["first_name"].string)
//            debugPrint(json["last_name"].string)
//            debugPrint(json["gender"].string)
//            
//            XCTAssert(true, "Pass")
//            expectation.fulfill()
//            
//            }, errorHandler: { (error) in
//                XCTAssert(false, "Failure")
//        })
//        
//        waitForExpectationsWithTimeout(30, handler: nil)
//
//    }
    
}
