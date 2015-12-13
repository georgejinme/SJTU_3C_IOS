//
//  TabbarController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/16.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import CoreBluetooth

class tabbarController: UITabBarController, CBCentralManagerDelegate, GCDAsyncUdpSocketDelegate, CBPeripheralDelegate {
    var video: UIImageView?
    var blueTooth: CBCentralManager?
    var peripherals: CBPeripheral?
    var services: CBService?
    var characteristics: CBCharacteristic?
    var udpSocket: GCDAsyncUdpSocket?
    
    var button: ButtonControlController?
    var sound: SoundControlController?
    var gesture: GestureControlController?
    var gravity: GravityControlController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.whiteColor()
        button = ButtonControlController()
        button!.tabBarItem.title = "button"
        sound = SoundControlController()
        sound!.tabBarItem.title = "sound"
        gesture = GestureControlController()
        gesture!.tabBarItem.title = "gesture"
        gravity = GravityControlController()
        gravity!.tabBarItem.title = "gravity"
        self.addChildViewController(button!)
        self.addChildViewController(sound!)
        self.addChildViewController(gesture!)
        self.addChildViewController(gravity!)
        self.view.backgroundColor = UIColor.whiteColor()
        initVideoView()
        initSocket()
        initBlueTooth()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVideoView(){
        video = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        video?.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(video!)
    }
    
    func initBlueTooth(){
        blueTooth = CBCentralManager(delegate: self, queue: nil)
        blueTooth?.delegate = self
    }
    
    func initSocket(){
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        do{
            try udpSocket!.bindToPort(12345)
            try udpSocket!.beginReceiving()
            print("receiving")
        }catch{
            print("bind error")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("blue tooth did discover peripheral")
        if (peripheral.name == "BT05"){
            self.peripherals = peripheral
            self.peripherals!.delegate = self
            blueTooth?.stopScan()
            self.blueTooth!.connectPeripheral(peripheral, options: nil)
        }
    }
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("blue tooth did connect")
        self.peripherals?.discoverServices(nil)
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("fail to connect")
    }
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("disconnect")
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("CBPeripheralDelegate didDiscoverServices")
        for service in peripheral.services!{
            print("Discover service \(service)")
            if (service.UUID == CBUUID(string: "FFE0")){
                self.services = service
                self.peripherals?.discoverCharacteristics(nil, forService: self.services!)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for characteristic in service.characteristics!{
            if (service == self.services! && characteristic.UUID == CBUUID(string: "FFE1")){
                print("FFEO Discover characteristic \(characteristic)")
                self.characteristics = characteristic
                button!.peripherals = self.peripherals
                button!.characteristics = self.characteristics
                sound!.peripherals = self.peripherals
                sound!.characteristics = self.characteristics
                gesture!.peripherals = self.peripherals
                gesture!.characteristics = self.characteristics
            }
        }
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
            blueTooth?.scanForPeripheralsWithServices(nil, options: nil)
        default:break
        }
    }
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        video?.image = UIImage(data: data)
    }
        
}
    
    


