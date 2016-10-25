//
//  ViewController.swift
//  ShrimpHttp
//
//  Created by rafael zhou on 09/30/2016.
//  Copyright (c) 2016 rafael zhou. All rights reserved.
//

import UIKit
import ShrimpHttp
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getFunction()
        postFunction()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getFunction(){
    

        ShrimpRequest().request(.GET, urlString: "https://httpbin.org/get").responseString ({ (string, response) in
            debugPrint("GET: \(string)")
        })
        
    }
    

    func postFunction() {
        let params = [
            "username":"rafael",
            "password":"123456"]
        
        
        ShrimpRequest().request(.POST, urlString: "http://www.mocky.io/v2/56c5b7a80f0000d027a204e2", parameters: params).responseJSON({ (json, response) in
            debugPrint(json["first_name"].string)
            debugPrint(json["last_name"].string)
            debugPrint(json["gender"].string)
            
            
            }, errorHandler: { (error) in
                
        })
        
        
    }

}

