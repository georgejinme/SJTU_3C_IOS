//
//  ViewController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    override func viewDidLoad() {
        initUI()
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        let videoButton = UIButton(frame: CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width / 2, 50))
        videoButton.setTitle("摄像头", forState: UIControlState.Normal)
        videoButton.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        videoButton.addTarget(self, action: "video:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(videoButton)
        
        let controlButton = UIButton(frame: CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, self.view.frame.size.width / 2, 50))
        controlButton.setTitle("控制机", forState: UIControlState.Normal)
        controlButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        controlButton.addTarget(self, action: "control:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(controlButton)
    }
    func video(sender: UIButton){
        self.presentViewController(videoController(), animated: true, completion: nil)
    }
    
    func control(sender: UIButton){
        self.presentViewController(tabbarController(), animated: true, completion: nil)
    }

}

