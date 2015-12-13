//
//  ButtonControllController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class ButtonControlController: UIViewController{
    var peripherals: CBPeripheral?
    var characteristics: CBCharacteristic?
    
    var upClick = 1
    var downClick = 1
    var leftClick = 1
    var rightClick = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        let left: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2 - 1, 50))
        left.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        left.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 200)
        left.setTitle("左转", forState: UIControlState.Normal)
        left.addTarget(self, action: "left:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(left)
        
        let right: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2 - 1, 50))
        right.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        right.center = CGPointMake(self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 200)
        right.setTitle("右转", forState: UIControlState.Normal)
        right.addTarget(self, action: "right:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(right)
        
        let up: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        up.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        up.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 251)
        up.setTitle("前进", forState: UIControlState.Normal)
        up.addTarget(self, action: "up:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(up)
        
        let down: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        down.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        down.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 149)
        down.setTitle("后退", forState: UIControlState.Normal)
        down.addTarget(self, action: "down:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(down)
        
        let stop: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        stop.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        stop.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 80)
        stop.setTitle("停止", forState: UIControlState.Normal)
        stop.addTarget(self, action: "stop:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stop)
    }
    
    func left(sender:UIButton){
        print("left")
        let speed = leftClick * 300
        rightClick = 0
        upClick = 0
        downClick = 0
        let data = "S\(speed)\nL".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func right(sender:UIButton){
        print("right")
        let speed = rightClick * 300
        leftClick = 0
        upClick = 0
        downClick = 0
        let data = "S\(speed)\nR".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    func up(sender:UIButton){
        print("up")
        let speed = upClick * 300
        rightClick = 0
        leftClick = 0
        downClick = 0
        let data = "S\(speed)\nA".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    func down(sender:UIButton){
        print("down")
        let speed = downClick * 300
        rightClick = 0
        upClick = 0
        leftClick = 0
        let data = "S\(speed)\nB".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func stop(sender:UIButton){
        print("stop")
        leftClick = 0
        rightClick = 0
        upClick = 0
        downClick = 0
        let data = "P".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
}