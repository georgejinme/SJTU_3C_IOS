//
//  ViewController.swift
//  3c
//
//  Created by 钩钩么么哒 on 15/10/9.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var client: UDPClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        client = UDPClient(addr: "192.168.1.130", port: 80)
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
        let (success, errmsg) = client!.send(str: imageData!)
        print(imageData!)
        if (success){
            print("success")
        }else{
            print("send: " + errmsg)
        }
        //print(image)
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

}

