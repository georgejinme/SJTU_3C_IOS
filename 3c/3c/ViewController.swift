//
//  ViewController.swift
//  3c
//
//  Created by 钩钩么么哒 on 15/10/9.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        let session: AVCaptureSession = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetMedium
        
        let device: AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let vedioInput: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
            session.addInput(vedioInput)
            
            let preview: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = AVLayerVideoGravityResizeAspectFill
            let rootLayer: CALayer = self.view.layer
            rootLayer.masksToBounds = true
            preview.frame = CGRectMake(0, 0, rootLayer.frame.size.width, rootLayer.frame.size.height)
            rootLayer.insertSublayer(preview, atIndex: 0)
            
            session.startRunning()
            
        }catch{
            print("error vedio input")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

