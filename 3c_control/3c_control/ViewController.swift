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
        initVideoView()
        //startSocketConnect()
        initBlueTooth()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVideoView(){
        vedioView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        vedioView?.backgroundColor = UIColor.blueColor()
        self.view.addSubview(vedioView!)
    }
    
    func startSocketConnect(){
        let server: UDPServer = UDPServer(addr: "192.168.1.127", port: 80)
        NSTimer.scheduledTimerWithTimeInterval(1.0 / 30, target: self, selector: "readImage:", userInfo: server, repeats: true)
        
    }
    
    func readImage(timer: NSTimer){
        let (data, _, _) = (timer.userInfo as! UDPServer).recv(1024 * 7)
        let imageRawData = NSData(bytes: data!, length: data!.count)
        let imageData = NSData(base64EncodedData: imageRawData, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = UIImage(data: imageData!)
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
        print("Central Manager is initialized")
        switch central.state{
        case CBCentralManagerState.Unauthorized:
            print("The app is not authorized to use Bluetooth low energy")
        case CBCentralManagerState.PoweredOff:
            print("Bluetooth is currently powered off")
        case CBCentralManagerState.PoweredOn:
            print("Bluetooth is currently powered on and available to use")
        default:break
        }
    }


}

