//
//  ViewController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initVedioView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVedioView(){
        let vedioView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        vedioView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(vedioView)
    }


}

