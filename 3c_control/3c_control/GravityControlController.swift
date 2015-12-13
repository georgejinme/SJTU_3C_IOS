//
//  GravityControlController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/14.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import CoreBluetooth

class GravityControlController: UIViewController{
    var xl: UILabel?
    var yl: UILabel?
    var zl: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initAccelerometer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        let left: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        left.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 250)
        left.text = "向左倾斜以左转"
        left.textAlignment = NSTextAlignment.Center
        self.view.addSubview(left)
        
        let right: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        right.center = CGPointMake(self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 250)
        right.text = "向右倾斜以右转"
        right.textAlignment = NSTextAlignment.Center
        self.view.addSubview(right)
        
        let up: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        up.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 300)
        up.text = "向上倾斜以前进"
        up.textAlignment = NSTextAlignment.Center
        self.view.addSubview(up)
        
        let down: UILabel = UILabel(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        down.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 200)
        down.text = "向下倾斜以倒退"
        down.textAlignment = NSTextAlignment.Center
        self.view.addSubview(down)
        
        let stop: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        stop.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        stop.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 80)
        stop.setTitle("停止", forState: UIControlState.Normal)
        stop.addTarget(self, action: "stop:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stop)
        
        xl = UILabel(frame: CGRectMake(0, self.view.frame.size.height - 350, self.view.frame.size.width / 3, 30))
        xl?.text = "x:0"
        xl?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(xl!)
        
        yl = UILabel(frame: CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height - 350, self.view.frame.size.width / 3, 30))
        yl?.text = "y:0"
        yl?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(yl!)
        
        zl = UILabel(frame: CGRectMake(self.view.frame.size.width / 3 * 2, self.view.frame.size.height - 350, self.view.frame.size.width / 3, 30))
        zl?.text = "z:0"
        zl?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(zl!)
    }
    
    func initAccelerometer(){
        let motion = CMMotionManager()
        let queue = NSOperationQueue()
        if (motion.accelerometerAvailable){
            motion.accelerometerUpdateInterval = 0.2
            motion.startAccelerometerUpdatesToQueue(queue, withHandler: {(accelerometerData, error) in
                if (error != nil){
                    motion.stopAccelerometerUpdates()
                }else{
                    dispatch_sync(dispatch_get_main_queue(), {
                        self.xl?.text = "x: \(accelerometerData!.acceleration.x)"
                        self.yl?.text = "y: \(accelerometerData!.acceleration.y)"
                        self.zl?.text = "z: \(accelerometerData!.acceleration.z)"
                    })
                }
                
            })
        }
    }
}