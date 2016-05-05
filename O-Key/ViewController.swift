//
//  ViewController.swift
//  O-Key
//
//  Created by 栄元優作 on 2016/04/13.
//  Copyright © 2016年 栄元優作. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var keyStateLabel: UILabel!
    
    var reqData:NSString!
    var url:NSURL!
    
    var name:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        nowUpdate()
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "nowUpdate", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //OPENを押した時
    @IBAction func open(sender: AnyObject) {
        if(keyStateLabel.text == "open"){
            SVProgressHUD.showErrorWithStatus("すでに空いています")
        }
        else{
            sendMessage("open")
        }
    }
    
    //LOCKを押した時
    @IBAction func lock(sender: AnyObject) {
        if(keyStateLabel.text == "lock"){
            SVProgressHUD.showErrorWithStatus("すでに閉まっています")
        }
        else{
            sendMessage("lock")
        }
    }
    
    
    //サーバにポストする
    func sendMessage(message:String){
        
        openButton.enabled = false
        lockButton.enabled = false
        
//        var reqData:NSString = "message=\(message)&name=\(name.objectForKey("name") as! String)"
//        var url = NSURL(string: "http://133.27.171.30/~eigen/open.php")
        
        if (message == "update") {
            reqData = "message=\(message)"
            url = NSURL(string: "http://133.27.171.30/~eigen/key/update.php")
            
        }else if(message == "open"){
            reqData = "message=\(message)&name=\(name.objectForKey("name") as! String)"
            url = NSURL(string: "http://133.27.171.30/~eigen/key/open.php")
        
        }else if(message == "lock"){
            reqData = "message=\(message)&name=\(name.objectForKey("name") as! String)"
            url = NSURL(string: "http://133.27.171.30/~eigen/key/close.php")
        }
        
        let myData:NSData = reqData.dataUsingEncoding(NSUTF8StringEncoding)!
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = myData
        
        if(message == "update"){
            let result = try? NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: self.postUpdate)
        }else if(message == "open"){
            let result = try? NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: self.postKeyState)
        
        }else if(message == "lock"){
            let result = try? NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: self.postKeyState)
        }
        
        openButton.enabled = true
        lockButton.enabled = true

    }
    
    func nowUpdate(){
        sendMessage("update")
    }
    //updateするとに呼ばれる
    func postUpdate(res:NSURLResponse?,data:NSData?,error:NSError?){
        if data != nil{
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            keyStateLabel.text = dataString
            print(dataString)
        }
    }
    //ボタンを押されたときに呼ばれる
    func postKeyState(res:NSURLResponse?,data:NSData?,error:NSError?){
        if data != nil{
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            print(dataString)
        }
    }

}

