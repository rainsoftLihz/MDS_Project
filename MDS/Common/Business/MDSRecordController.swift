//
//  MDSRecordController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/13.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSRecordController: MDSBaseController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startBtn:UIButton = UIView.createBtn(title: "开始录音", titleColor: .black, fontSize: 18)
        
        let endBtn:UIButton = UIView.createBtn(title: "结束录音", titleColor: .black, fontSize: 18)
        
        let playBtn:UIButton = UIView.createBtn(title: "播放录音", titleColor: .black, fontSize: 18)
        
        let endPlayBtn:UIButton = UIView.createBtn(title: "播放停止", titleColor: .black, fontSize: 18)
        
        self.view.addSubViews([startBtn,endBtn,playBtn,endPlayBtn])
        
        startBtn.myFrame(100, 100, 100, 50)
        endBtn.myFrame(100, 200, 100, 50)
        playBtn.myFrame(100, 300, 100, 50)
        endPlayBtn.myFrame(100, 400, 100, 50)
        
        startBtn.addTarget(self, action: #selector(startRecord), for: .touchUpInside)
        endBtn.addTarget(self, action: #selector(endRecord), for: .touchUpInside)
        playBtn.addTarget(self, action: #selector(startPlayer), for: .touchUpInside)
        endPlayBtn.addTarget(self, action: #selector(endPlayer), for: .touchUpInside)
    }
    
    @objc func startRecord(){
        MDSRecordManager.manger.beginRecord()
    }
    
    @objc func endRecord(){
        MDSRecordManager.manger.stopRecord()
    }
    
    @objc func startPlayer(){
        //https://96.f.1ting.com/local_to_cube_202004121813/96kmp3/2019/12/30/30c_Idol/01.mp3
        let url:String = "http://res-tts.iciba.com/tts_new_dj/9/7/0/970fab4c80ec834cb527f2618011d26c.mp3"
        MDSPlayerManager.manger.startPlay(url:url)
    }
    
    @objc func endPlayer(){
        MDSPlayerManager.manger.pause()
    }
}
