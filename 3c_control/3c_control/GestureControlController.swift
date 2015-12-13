//
//  GestureControlController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class GestureControlController: UIViewController{
    var peripherals: CBPeripheral?
    var characteristics: CBCharacteristic?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initGesture()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        let left: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        left.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 250)
        left.text = "向左滑动以左转"
        left.textAlignment = NSTextAlignment.Center
        self.view.addSubview(left)
        
        let right: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        right.center = CGPointMake(self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 250)
        right.text = "向右滑动以右转"
        right.textAlignment = NSTextAlignment.Center
        self.view.addSubview(right)
        
        let up: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        up.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 300)
        up.text = "向上滑动以前进"
        up.textAlignment = NSTextAlignment.Center
        self.view.addSubview(up)
        
        let down: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        down.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 200)
        down.text = "向下滑动以倒退"
        down.textAlignment = NSTextAlignment.Center
        self.view.addSubview(down)
        
        let stop: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        stop.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        stop.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 80)
        stop.setTitle("停止", forState: UIControlState.Normal)
        stop.addTarget(self, action: "stop:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stop)
    }
    
    func initGesture(){
        var swipe: UISwipeGestureRecognizer?
        swipe = UISwipeGestureRecognizer(target: self, action: "leftSwipe:")
        swipe?.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipe!)
        
        swipe = UISwipeGestureRecognizer(target: self, action: "rightSwipe:")
        swipe?.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipe!)
        
        swipe = UISwipeGestureRecognizer(target: self, action: "upSwipe:")
        swipe?.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipe!)
        
        swipe = UISwipeGestureRecognizer(target: self, action: "downSwipe:")
        swipe?.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe!)
    }
    
    func leftSwipe(sender: AnyObject){
        print("left swipe")
        let data = "L".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func rightSwipe(sender: AnyObject){
        print("right swipe")
        let data = "R".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func upSwipe(sender: AnyObject){
        print("up swipe")
        let data = "A".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func downSwipe(sender: AnyObject){
        print("down swipe")
        let data = "B".dataUsingEncoding(NSUTF8StringEncoding)
        self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
    }
}