//
//  ViewController.swift
//  ShrimpHttp
//
//  Created by rafael zhou on 09/30/2016.
//  Copyright (c) 2016 rafael zhou. All rights reserved.
//

import UIKit
import Shrimp

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
    

        Shrimp.request(.GET, urlString: "http://httpbin.org/get").responseString({ (result, response) in
            debugPrint("GET: \(result)")
        }, errorHandler: { (error) in
            
        })

        
    }
    

    func postFunction() {
        let params = [
            "username":"rafael",
            "password":"123456"]
        
        Shrimp.request(.POST, urlString: "http://www.mocky.io/v2/56c5b7a80f0000d027a204e2", parameters: params)
            .responseJSONObject({ (json, response) in
            
                let dic = json as! [String:String]
                debugPrint(dic["first_name"])
                debugPrint(dic["last_name"])
                
            }) { (error) in
                
        }
        
        
    }

}

