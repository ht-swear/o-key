//
//  LoginViewController.swift
//  O-Key
//
//  Created by 栄元優作 on 2016/04/22.
//  Copyright © 2016年 栄元優作. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var NameTextFIeld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        let userName = NameTextFIeld.text!
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(userName, forKey: "name")
        ud.synchronize()
        
        print(userName)
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
