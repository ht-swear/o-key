//
//  LoginViewController.swift
//  O-Key
//
//  Created by 栄元優作 on 2016/04/22.
//  Copyright © 2016年 栄元優作. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextFIeld: UITextField!
    var name:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        nameTextFIeld.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        //テキストの中身が空っぽだったら通知
        if(nameTextFIeld.text == ""){
            SVProgressHUD.showErrorWithStatus("名前が入力されていません")
        //テキストの中身があったらアラートを出す
        }else{
            let userName:String = nameTextFIeld.text! as String

            let alertController = UIAlertController(title: "\(userName)でよろしいですか？", message: "", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default){
                action in
                
                let reqData:NSString = "name=\(userName)"
                let myData:NSData = reqData.dataUsingEncoding(NSUTF8StringEncoding)!
                let url: NSURL! = NSURL(string: "http://life-cloud.ht.sfc.keio.ac.jp/~eigen/key/login.php")
                let request = NSMutableURLRequest(URL: url)
                
                request.HTTPMethod = "POST"
                request.HTTPBody = myData
                //データベースに入れる
                let result = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                
                self.name.setObject(userName, forKey: "name")
                
                let resData = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
                print(resData)
                //ページ移動
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let firstViewController = storyBoard.instantiateViewControllerWithIdentifier("FirstViewController")
                self.presentViewController(firstViewController, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "CANCEL", style: .Cancel){
                action in
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
