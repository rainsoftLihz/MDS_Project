//
//  MDSGoToScanController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
class MDSGoToScanController: MDSBaseController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myNavView.isHidden = true
        
        let takeBtn:UIButton = UIButton.init(type: .custom)
        takeBtn.setBackgroundImage(kImage("camera-black"), for: .normal)
        takeBtn.setBackgroundImage(kImage("camera-black"), for: .highlighted)
        takeBtn.addTarget(self, action: #selector(gotoScan), for: .touchUpInside)
        self.view.addSubview(takeBtn)
        takeBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 60))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
        
        
        let camBtn:UIButton = UIView.createBtn(title: "拍照识别", titleColor: .black, fontSize: 18)
        camBtn.addTarget(self, action: #selector(gotoScan), for: .touchUpInside)
        self.view.addSubview(camBtn)
        camBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 200, height: 40))
            make.centerX.equalToSuperview()
            make.top.equalTo(takeBtn.snp_bottom)
        }
    }

    @objc func gotoScan(){
        let vc:MDSAIScanController = MDSAIScanController.init()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
