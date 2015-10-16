//
//  VideoController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/16.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//
import UIKit
import AVFoundation

class videoController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, EMCallManagerDelegate {
    var statusLabel: UILabel?
    var videoConnect = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        initStatusView()
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername("3cvideo", password: "941102", completion: {userinfo, error in
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
            initVideoCall(callSession)
        }
    }
    
    func initVideoCall(videoSession: EMCallSession){
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
        
        videoSession.displayView = nil
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        if CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess{
            let bufferPtr = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0))
            let bufferPtr1 = UnsafeMutablePointer<UInt8>(CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1))
            
            let width: size_t = CVPixelBufferGetWidth(imageBuffer)
            let height: size_t = CVPixelBufferGetHeight(imageBuffer)
            
            let bytesrow0: size_t = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0)
            let bytesrow1: size_t = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 1)
            
            let imageDataBuffer = UnsafeMutablePointer<UInt8>.alloc(width * height * 3 / 2)
            let pY = bufferPtr
            var pUV = bufferPtr1
            var pU = imageDataBuffer + width * height
            var pV = pU + width * height / 4
            for (var i = 0; i < height; i++){
                memcpy(imageDataBuffer + i * width, pY + i * bytesrow0, width)
            }
            
            for (var j = 0; j < height / 2; j++){
                for (var i = 0; i < width / 2; i++){
                    pU.memory = pUV[i << 1]
                    pV.memory = pUV[(i << 1) + 1]
                    ++pU
                    ++pV
                }
                pUV += bytesrow1
            }
            
            YUV420spRotate90(bufferPtr, src: imageDataBuffer, srcWidth: width, srcHeight: height)
            EaseMob.sharedInstance().callManager.processPreviewData(UnsafeMutablePointer<Int8>(bufferPtr), width: Int32(width), height: Int32(height))
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
        }
    }
    
    func YUV420spRotate90(dst: UnsafeMutablePointer<UInt8>, src: UnsafeMutablePointer<UInt8>, srcWidth: size_t, srcHeight: size_t){
        let wh: size_t = srcWidth * srcHeight
        let uvHeight: size_t = srcHeight >> 1
        let uvWidth: size_t = srcWidth >> 1
        let uvwh: size_t = wh >> 2
        var k = 0
        for (var i = 0; i < srcWidth; i++){
            var nPos = wh - srcWidth
            for (var j = 0; k < srcHeight; j++){
                dst[k] = src[nPos + i]
                k++
                nPos -= srcWidth
            }
        }
        for (var i = 0; i < uvWidth; i++){
            var nPos = wh + uvwh - uvWidth
            for (var j = 0; j < uvHeight; j++){
                dst[k] = src[nPos + i]
                dst[k + uvwh] = src[nPos + i + uvwh]
                k++
                nPos -= uvWidth
            }
        }
    }
    
}

