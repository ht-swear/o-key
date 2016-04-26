//
//  ViewController.swift
//  O-Key
//
//  Created by 栄元優作 on 2016/04/13.
//  Copyright © 2016年 栄元優作. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    
    var name:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //push OPEN
    @IBAction func open(sender: AnyObject) {
        sendMessage("open")
            }
    
    //push LOCK
    @IBAction func lock(sender: AnyObject) {
        sendMessage("lock")
    }
    
    
    //send message to server
    func sendMessage(message:String){
        
        openButton.enabled = false
        lockButton.enabled = false
        
        let reqData:NSString = "message=\(message)&name=\(name.objectForKey("name") as! String)"
        let myData:NSData = reqData.dataUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: "http://133.27.171.30/~eigen/open.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = myData
        let result = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let data = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
        print(data)
        
        openButton.enabled = true
        lockButton.enabled = true

    }

}

