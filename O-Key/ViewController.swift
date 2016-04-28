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
    @IBOutlet weak var keyStateLabel: UILabel!
    
    var name:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowUpdate()
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nowUpdate", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //OPENを押した時
    @IBAction func open(sender: AnyObject) {
        sendMessage("open")
            }
    
    //LOCKを押した時
    @IBAction func lock(sender: AnyObject) {
        sendMessage("lock")
    }
    
    
    //サーバにポストする
    func sendMessage(message:String){
        
        openButton.enabled = false
        lockButton.enabled = false
        
        var reqData:NSString = "message=\(message)&name=\(name.objectForKey("name") as! String)"
        var url = NSURL(string: "http://133.27.171.30/~eigen/open.php")
        
        if (message == "update") {
            reqData = "message=\(message)"
            url = NSURL(string: "http://133.27.171.30/~eigen/update.php")
            
        }
        
        let myData:NSData = reqData.dataUsingEncoding(NSUTF8StringEncoding)!
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = myData
        let result = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        let data = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
        print(data)
        keyStateLabel.text = data
        
        openButton.enabled = true
        lockButton.enabled = true

    }
    
    func nowUpdate(){
        sendMessage("update")
    }

}

