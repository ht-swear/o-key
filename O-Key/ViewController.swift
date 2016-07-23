//
//  ViewController.swift
//  O-Key
//
//  Created by 栄元優作 on 2016/04/13.
//  Copyright © 2016年 栄元優作. All rights reserved.
//

import UIKit
import CoreBluetooth
import SVProgressHUD

class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic:CBCharacteristic!
    var aCharacteristic: CBCharacteristic!
    let serviceUUIDs = [CBUUID(string:"0000")]
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var keyStateLabel: UILabel!
    
    var reqData:NSString!
    var url:NSURL!
    
    var name:NSUserDefaults = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case .PoweredOff:
            print("BLE PoweredOff")
        case .PoweredOn:
            print("BLE PoweredOn")
            //Peripheral探索開始
            central.scanForPeripheralsWithServices(self.serviceUUIDs, options: nil)
            /* ↑の第1引数はnilは非推奨。
             該当サービスのCBUUIDオブジェクトの配列が望ましい */
        case .Resetting:
            print("BLE Resetting")
        case .Unauthorized:
            print("BLE Unauthorized")
        case .Unknown:
            print("BLE Unknown")
        case .Unsupported:
            print("BLE Unsupported")
        }
    }
    
    //指定したBLE見つけたら接続
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("name: \(peripheral.name)")
        print("UUID: \(peripheral.identifier.UUIDString)")
        print("advertisementData: \(advertisementData)")
        print("RSSI: \(RSSI)")
        self.peripheral = peripheral
        // 接続開始
        self.centralManager.connectPeripheral(peripheral, options: nil)
        self.centralManager.stopScan()
    }
    
    // ペリフェラルへの接続が成功すると呼ばれる
    func centralManager(central: CBCentralManager,
                        didConnectPeripheral peripheral: CBPeripheral)
    {
        print("接続成功！")
        // サービス探索結果を受け取るためにデリゲートをセット
        peripheral.delegate = self
        // サービス探索開始
        peripheral.discoverServices(nil)
    }
    
    // サービス発見時に呼ばれる
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if error != nil {
            print("エラー: \(error)")
            return
        }
        let services: NSArray = peripheral.services!
        print("\(services.count) 個のサービスを発見！ \(services)")
        for obj in services {
            if let service = obj as? CBService {
                // キャラクタリスティック探索開始
                peripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    // ペリフェラルへの接続が失敗すると呼ばれる
    func centralManager(central: CBCentralManager,didFailToConnectPeripheral peripheral: CBPeripheral,error: NSError?)
    {
        print("接続失敗・・・")
    }
    
    // キャラクタリスティック発見時に呼ばれる
    func peripheral(peripheral: CBPeripheral,didDiscoverCharacteristicsForService service: CBService,error: NSError?)
    {
        if error != nil {
            print("エラー: \(error)")
            return
        }
        let characteristics: NSArray = service.characteristics!
        print("\(characteristics.count) 個のキャラクタリスティックを発見！ \(characteristics)")
        // 特定のキャラクタリスティックをプロパティに保持
        let uuid = CBUUID(string:"0001")
        for aCharacteristic in characteristics {
            if aCharacteristic.UUID == uuid {
                //usernameの値を送ったとき
                let ngo = name.objectForKey("name") as! String
                let data = ngo.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                peripheral.writeValue(data!, forCharacteristic: aCharacteristic as! CBCharacteristic, type: CBCharacteristicWriteType.WithResponse)
                break;
            }
        }
    }
    //write成功時に呼ばれる
    func peripheral(peripheral: CBPeripheral,didWriteValueForCharacteristic characteristic: CBCharacteristic,error: NSError?)
    {
        if let error = error {
            print("Write失敗...error: \(error)")
            return
        }
        
        print("Write成功！")
    }
    
    func centralManager(central: CBCentralManager,didDisconnectPeripheral peripheral:CBPeripheral,error: NSError?) {
        print("接続が切断されました。")
        
        if error != nil {
            print("エラー: \(error)")
        }
        
        self.peripheral = nil
        self.characteristic = nil
    }
    
//    override func viewWillAppear(animated: Bool) {
//        nowUpdate()
//        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "nowUpdate", userInfo: nil, repeats: true)
//    }
    
    //OPENを押した時
    @IBAction func open(sender: AnyObject) {
//        if(keyStateLabel.text == "open"){
//            SVProgressHUD.showErrorWithStatus("すでに空いています")
//        }
//        else{
//            sendMessage("open")
//        }
    }
    
    //LOCKを押した時
    @IBAction func lock(sender: AnyObject) {
//        if(keyStateLabel.text == "lock"){
//            SVProgressHUD.showErrorWithStatus("すでに閉まっています")
//        }
//        else{
//            sendMessage("lock")
//        }
    }
    
    
    //サーバにポストする
    func sendMessage(message:String){
        
        openButton.enabled = false
        lockButton.enabled = false
        
//        var reqData:NSString = "message=\(message)&name=\(name.objectForKey("name") as! String)"
//        var url = NSURL(string: "http://133.27.171.30/~eigen/open.php")
        
        if (message == "update") {
            reqData = "message=\(message)"
            url = NSURL(string: "http://o-key.ht.sfc.keio.ac.jp/~eigen/key/update.php")
            
        }else if(message == "open"){
            reqData = "message=\(message)&name=\(name.objectForKey("name") as! String)"
            url = NSURL(string: "http://o-key.ht.sfc.keio.ac.jp/~eigen/key/open.php")
        
        }else if(message == "lock"){
            reqData = "message=\(message)&name=\(name.objectForKey("name") as! String)"
            url = NSURL(string: "http://o-key.ht.sfc.keio.ac.jp/~eigen/key/close.php")
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

