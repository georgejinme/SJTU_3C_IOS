//
//  SoundControlController.swift
//  3c_control
//
//  Created by 钩钩么么哒 on 15/10/10.
//  Copyright © 2015年 钩钩么么哒. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class SoundControlController: UIViewController, IFlySpeechRecognizerDelegate{
    var speechRecognizer: IFlySpeechRecognizer?
    var soundText: UITextView?
    
    var peripherals: CBPeripheral?
    var characteristics: CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initRecognizer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUI(){
        let startButton: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        startButton.setTitle("开始", forState: UIControlState.Normal)
        startButton.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        startButton.center = CGPointMake(self.view.frame.size.width / 4, self.view.frame.size.height - 100)
        startButton.addTarget(self, action: "startSound:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startButton)
        
        let stopButton: UIButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width / 2, 50))
        stopButton.setTitle("停止并解析", forState: UIControlState.Normal)
        stopButton.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        stopButton.center = CGPointMake(self.view.frame.size.width / 4 * 3, self.view.frame.size.height - 100)
        stopButton.addTarget(self, action: "stopSound:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stopButton)
        
        soundText = UITextView(frame: CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 425))
        soundText?.editable = false
        soundText?.text = "点击[开始]按钮开始录音"
        self.view.addSubview(soundText!)
    }
    
    func initRecognizer(){
        speechRecognizer = IFlySpeechRecognizer.sharedInstance() as? IFlySpeechRecognizer
        speechRecognizer?.delegate = self
        speechRecognizer?.setParameter("iat", forKey: IFlySpeechConstant.IFLY_DOMAIN())
        speechRecognizer?.setParameter("asr.pcm", forKey: IFlySpeechConstant.ASR_AUDIO_PATH())
        speechRecognizer?.setParameter("30000", forKey: IFlySpeechConstant.SPEECH_TIMEOUT())
        speechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.VAD_EOS())
        speechRecognizer?.setParameter("3000", forKey: IFlySpeechConstant.VAD_BOS())
        speechRecognizer?.setParameter("20000", forKey: IFlySpeechConstant.NET_TIMEOUT())
        speechRecognizer?.setParameter("16000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        speechRecognizer?.setParameter("zh_cn", forKey: IFlySpeechConstant.LANGUAGE())
        speechRecognizer?.setParameter("mandarin", forKey: IFlySpeechConstant.ACCENT())
        speechRecognizer?.setParameter("0", forKey: IFlySpeechConstant.ASR_PTT())
        speechRecognizer?.setParameter("1", forKey: IFlySpeechConstant.AUDIO_SOURCE())
        speechRecognizer?.setParameter("json", forKey: IFlySpeechConstant.RESULT_TYPE())
    }
    
    func startSound(sender: UIButton){
        var res = false
        if (speechRecognizer == nil){
            self.initRecognizer()
        }else{
            res = speechRecognizer!.startListening()
        }
        if (!res){
            soundText?.text = "启动识别服务失败，请稍后重试"
        }
    }
    
    func stopSound(sender: UIButton){
        speechRecognizer?.stopListening()
    }
    
    func onBeginOfSpeech() {
        soundText?.text = "正在录音"
    }
    
    func onEndOfSpeech() {
        soundText?.text = "停止录音"
    }
    func onError(errorCode: IFlySpeechError!) {
        if (errorCode.errorCode != 0){
            soundText?.text = "发生错误" + errorCode.description
        }
    }
    func onResults(results: [AnyObject]!, isLast: Bool) {
        var resJSON = ""
        let dic: NSDictionary = results[0] as! NSDictionary
        let keys = dic.allKeys
        for each in keys {
            resJSON += each as! String
        }
        let soundRes = stringFromJson(resJSON)
        if (soundRes == "前进"){
            let data = "A".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "后退"){
            let data = "B".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "左转"){
            let data = "Z".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "快速左转"){
            let data = "Y".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "急左转"){
            let data = "X".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "右转"){
            let data = "T".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "快速右转"){
            let data = "S".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "急右转"){
            let data = "R".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }else if (soundRes == "停止"){
            let data = "P".dataUsingEncoding(NSUTF8StringEncoding)
            self.peripherals?.writeValue(data!, forCharacteristic: self.characteristics!, type: CBCharacteristicWriteType.WithoutResponse)
        }
        self.soundText?.text = soundRes
    }
    
    func stringFromJson(text: String) -> String{
        var res = ""
        do{
            let resDic: NSDictionary = try NSJSONSerialization.JSONObjectWithData(text.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            let wordArray = resDic.objectForKey("ws")
            for (var i = 0; i < wordArray?.count; ++i){
                let wsDic: NSDictionary = wordArray?.objectAtIndex(i) as! NSDictionary
                let cwArray = wsDic.objectForKey("cw")
                for (var j = 0; j < cwArray?.count; ++j){
                    let wDic: NSDictionary = cwArray?.objectAtIndex(j) as! NSDictionary
                    let str = wDic.objectForKey("w") as! String
                    res += str
                }
            }
            return res
        }catch{
            return "解析失败"
        }
    }
}