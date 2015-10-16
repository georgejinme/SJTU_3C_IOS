//
//  TabbarController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/16.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import CoreBluetooth

class tabbarController: UITabBarController, CBCentralManagerDelegate, EMCallManagerDelegate {
    
    var vedioView: OpenGLView20?
    var blueTooth: CBCentralManager?
    var videoCall: EMCallSession?
    var statusLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.whiteColor()
        let button = ButtonControlController()
        button.tabBarItem.title = "button"
        let sound = SoundControlController()
        sound.tabBarItem.title = "sound"
        let gesture = GestureControlController()
        gesture.tabBarItem.title = "gesture"
        let gravity = GravityControlController()
        gravity.tabBarItem.title = "gravity"
        self.addChildViewController(button)
        self.addChildViewController(sound)
        self.addChildViewController(gesture)
        self.addChildViewController(gravity)
        self.view.backgroundColor = UIColor.whiteColor()
        initVideoView()
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("3ccontrol", password: "941102", completion: {userinfo, error in
            if (error == nil){
                print("login success")
                print(userinfo)
                self.initVideoCall()
            }else{
                print("login error")
            }
            }, onQueue: nil)
        //initBlueTooth()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVideoView(){
        vedioView = OpenGLView20(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        vedioView?.backgroundColor = UIColor.clearColor()
        vedioView?.sessionPreset = AVCaptureSessionPreset352x288
        self.view.addSubview(vedioView!)
        
        statusLabel = UILabel(frame: CGRectMake(0, 20, self.view.frame.size.width, 30))
        statusLabel?.text = "Status"
        statusLabel?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(statusLabel!)
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
    
    func initVideoCall(){
        statusLabel?.text = "Call..."
        EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
        videoCall = EaseMob.sharedInstance().callManager.asyncMakeVideoCall("3c", timeout: 5, error: nil)
        videoCall?.displayView = self.vedioView
        EaseMob.sharedInstance().callManager.processPreviewData(nil, width: 0, height: 0)
    }
    
    func callSessionStatusChanged(callSession: EMCallSession!, changeReason reason: EMCallStatusChangedReason, error: EMError!) {
        if (videoCall?.sessionId != callSession.sessionId){
            return
        }
        if (error != nil){
            let alert = UIAlertView(title: "Error", message: error.description, delegate: self, cancelButtonTitle: "Sure")
            alert.show()
            statusLabel?.text = "Call Fail"
            return
        }
        if (callSession.status == EMCallSessionStatus.eCallSessionStatusDisconnected){
            if (reason == EMCallStatusChangedReason.eCallReason_Hangup){
                statusLabel?.text = "Call Cancel"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Reject){
                statusLabel?.text = "Call Reject"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Busy){
                statusLabel?.text = "Call Busy"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Null){
                statusLabel?.text = "Call Over(Me)"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Offline){
                statusLabel?.text = "Call Offline"
            }else if (reason == EMCallStatusChangedReason.eCallReason_NoResponse){
                statusLabel?.text = "Call No Response"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Hangup){
                statusLabel?.text = "Call Over(Other)"
            }else if (reason == EMCallStatusChangedReason.eCallReason_Failure){
                statusLabel?.text = "Call Fail"
            }
        }else if (callSession.status == EMCallSessionStatus.eCallSessionStatusAccepted){
            if (callSession.connectType == EMCallConnectType.eCallConnectTypeRelay){
                statusLabel?.text = "Call Speak Relay"
            }else if (callSession.connectType == EMCallConnectType.eCallConnectTypeDirect){
                statusLabel?.text = "Call Speak Direct"
            }else{
                statusLabel?.text = "Call Speak"
            }
        }
        
    }
    
    
}

