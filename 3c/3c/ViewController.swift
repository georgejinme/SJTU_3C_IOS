//
//  ViewController.swift
//  3c
//
//  Created by 钩钩么么哒 on 15/10/9.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, EMCallManagerDelegate {
    var statusLabel: UILabel?
    var videoConnect = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initStatusView()
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("3c", password: "941102", completion: {userinfo, error in
            if (error == nil){
                print("login success")
                print(userinfo)
                EaseMob.sharedInstance().callManager.addDelegate(self, delegateQueue: nil)
            }else{
                print("login error")
            }
        }, onQueue: nil)
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
            
            let vedioOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
            vedioOutput.videoSettings = NSDictionary(dictionary: [kCVPixelBufferPixelFormatTypeKey: NSNumber(unsignedInt: kCVPixelFormatType_32BGRA)]) as [NSObject : AnyObject]
            session.addOutput(vedioOutput)
            
            let queue: dispatch_queue_t = dispatch_queue_create("vedio", nil)
            vedioOutput.setSampleBufferDelegate(self, queue: queue)
            
        }catch{
            print("error vedio input")
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let image = imageFromSampleBuffer(sampleBuffer)
        let data = UIImageJPEGRepresentation(image, 1.0)
        let imageData = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
    
    func imageFromSampleBuffer(sampleBuffer: CMSampleBufferRef) -> UIImage{
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let context: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedFirst.rawValue)!
        let quartzImage: CGImageRef = CGBitmapContextCreateImage(context)!
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
        
        let image: UIImage = UIImage(CGImage: quartzImage)
        return image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initStatusView(){
        statusLabel = UILabel(frame: CGRectMake(0, 20, self.view.frame.size.width, 30))
        statusLabel?.text = "Status"
        statusLabel?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(statusLabel!)
    }
    
    func callSessionStatusChanged(callSession: EMCallSession!, changeReason reason: EMCallStatusChangedReason, error: EMError!) {
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
        
        if (!videoConnect){
            EaseMob.sharedInstance().callManager.asyncAnswerCall(callSession.sessionId)
            videoConnect = true
            initVideoCall()
        }
    }
    
    func initVideoCall(){
        
    }

}

