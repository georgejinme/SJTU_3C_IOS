//
//  ViewController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var vedioView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        initVedioView()
        startSocketConnect()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVedioView(){
        vedioView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        //vedioView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(vedioView!)
    }
    
    func startSocketConnect(){
        let server: TCPServer = TCPServer(addr: "192.168.1.127", port: 80)
        let (success, msg) = server.listen()
        if (success){
            if let client = server.accept(){
                print("new client from: " + client.addr + ":" + "\(client.port)")
                NSTimer.scheduledTimerWithTimeInterval(1.0 / 30, target: self, selector: "readImage:", userInfo: client, repeats: true)
            }else{
                print("accept error")
            }
        }else{
            print("listen: " + msg)
        }
    }
    
    func readImage(timer: NSTimer){
        let data = (timer.userInfo as! TCPClient).read(1024 * 3)
        print(data)
        let image = UIImage(data: NSData(bytes: data!, length: data!.count))
        if (image != nil){
            vedioView?.image = image
            print(image)
        }
    }


}

