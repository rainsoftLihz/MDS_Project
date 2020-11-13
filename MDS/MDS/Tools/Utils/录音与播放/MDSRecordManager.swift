//
//  MDSRecordManager.swift
//  MDS
//
//  Created by rainsoft on 2020/11/13.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import AVFoundation

private let shareManger = MDSRecordManager()
class MDSRecordManager: NSObject {
    var recorder:AVAudioRecorder?
    
    let filePath:String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/record.wav"))!
    
    //单例
    class var manger:MDSRecordManager{
        return shareManger
    }
    
    
    //开始录音
    func beginRecord() {
        //设置session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setActive(true);
        }catch
        {
            print("session 设置失败")
        }
        //录音设置
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 16000),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 1),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        //开始录音
        do {
            let url = URL(string: filePath)
            self.recorder = try AVAudioRecorder(url: url!, settings: recordSetting)
            self.recorder!.prepareToRecord()
            self.recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }
    
    
    //结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(filePath)")
            }else {
                print("没有录音，但是依然结束它")
            }
            self.recorder!.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
}
