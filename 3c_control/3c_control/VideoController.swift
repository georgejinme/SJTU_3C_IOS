//
//  VideoController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/16.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//
import UIKit
import AVFoundation

class videoController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, GCDAsyncUdpSocketDelegate {
    var udpSocket: GCDAsyncUdpSocket?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        initVideoCall()
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func initVideoCall(){
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
            session.commitConfiguration()
        }catch{
            print("error vedio input")
        }

    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let context: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue)!
        let quartzImage: CGImageRef = CGBitmapContextCreateImage(context)!
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
        
        let displayImage = UIImage(CGImage: quartzImage, scale: 1.0, orientation: UIImageOrientation.Up)
        let passImage = UIImageJPEGRepresentation(displayImage, 0.1)
        udpSocket?.sendData(passImage, toHost: "192.168.1.101", port: 12345, withTimeout: -1, tag: 0)
    }
}

