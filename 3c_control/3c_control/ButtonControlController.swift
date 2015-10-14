//
//  ButtonControllController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import Foundation
import UIKit

class ButtonControlController: UIViewController{
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
        self.view.addSubview(left)
        
        let right: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2 - 1, 50))
        right.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        right.center = CGPointMake(self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 200)
        right.setTitle("右转", forState: UIControlState.Normal)
        self.view.addSubview(right)
        
        let up: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        up.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        up.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 251)
        up.setTitle("前进", forState: UIControlState.Normal)
        self.view.addSubview(up)
        
        let down: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        down.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        down.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 149)
        down.setTitle("后退", forState: UIControlState.Normal)
        self.view.addSubview(down)
    }
}