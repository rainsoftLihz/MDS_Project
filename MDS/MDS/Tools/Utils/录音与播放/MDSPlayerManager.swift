//
//  MDSPlayerManager.swift
//  MDS
//
//  Created by rainsoft on 2020/11/13.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import AVFoundation

private let shareManger = MDSPlayerManager()
class MDSPlayerManager: NSObject,AVAudioPlayerDelegate {
    var player:AVAudioPlayer!
    //单例
    class var manger:MDSPlayerManager{
        return shareManger
    }
    
    //播放
    func startPlay(url:String) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.setActive(true)
            //设置外音播放
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            let sound:URL = {
                if url.contains("http://") || url.contains("https://"){
                    return URL(string: url)! as URL
                }else{
                    return URL(fileURLWithPath: url) as URL
                }
            }()
            let data = try Data.init(contentsOf: sound, options: Data.ReadingOptions.alwaysMapped)

            player = try? AVAudioPlayer(data: data as Data )
            player.numberOfLoops = 1
            player.volume = 1.0
            player.delegate = self
            if player!.prepareToPlay() && player!.play() {
                print("success")
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute:{
                    print("currentTime=====\(self.player.currentTime)")
                    print("duration=====\(self.player.duration)")
                })
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute:{
                    print("currentTime=====\(self.player.currentTime)")
                    print("duration=====\(self.player.duration)")
                })
            } else {
                print("error")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("播放完成")
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5, execute:{
                //重新播放
                self.player.play()
            })
        }
    }
    
    //结束
    func stop() {
        self.player?.stop()
    }
    
    //暂停
    func pause(){
        self.player?.pause()
    }
    
    //暂停 ---> 恢复播放
    func play()  {
        self.player!.play()
    }
}
