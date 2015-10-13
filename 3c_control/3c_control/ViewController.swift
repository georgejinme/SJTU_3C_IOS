//
//  ViewController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UITabBarController, CBCentralManagerDelegate {
    
    var vedioView: UIImageView?
    var blueTooth: CBCentralManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        initVedioView()
        startSocketConnect()
        initBlueTooth()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVedioView(){
        vedioView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        self.view.addSubview(vedioView!)
    }
    
    func startSocketConnect(){
        let server: UDPServer = UDPServer(addr: "192.168.1.127", port: 80)
        /*let (success, msg) = server.listen()
        if (success){
            if let client = server.accept(){
                print("new client from: " + client.addr + ":" + "\(client.port)")
                NSTimer.scheduledTimerWithTimeInterval(1.0 / 30, target: self, selector: "readImage:", userInfo: client, repeats: true)
            }else{
                print("accept error")
            }
        }else{
            print("listen: " + msg)
        }*/
        NSTimer.scheduledTimerWithTimeInterval(1.0 / 30, target: self, selector: "readImage:", userInfo: server, repeats: true)
        
    }
    
    func readImage(timer: NSTimer){
        let (data, _, _) = (timer.userInfo as! UDPServer).recv(1024 * 7)
        //let data = (timer.userInfo as! TCPClient).read(1024 * 3)
        let imageStr = String(bytes: data!, encoding: NSUTF8StringEncoding)
        let imageData = NSData(base64EncodedString: imageStr!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        //let image = UIImage(data: NSData(bytes: data!, length: data!.count))
        if (image != nil){
            vedioView?.image = image
            print(image)
        }
    }
    
    func initBlueTooth(){
        blueTooth = CBCentralManager(delegate: self, queue: nil)
        blueTooth?.delegate = self
        blueTooth?.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("blue tooth did discover peripheral")
        self.blueTooth?.connectPeripheral(peripheral, options: NSDictionary(dictionary: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: NSNumber(bool: true)]) as? [String : AnyObject])
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("blue tooth did connect")
        
    }
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("blue tooth state update")
    }


}

