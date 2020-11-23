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
        
        
        let camBtn:UIButton = UIView.createBtn(title: "拍照识别", titleColor: .red, fontSize: 26)
        camBtn.addTarget(self, action: #selector(gotoScan), for: .touchUpInside)
        self.view.addSubview(camBtn)
        camBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 200, height: 80))
            make.center.equalToSuperview()
        }
    }

    @objc func gotoScan(){
        let vc:MDSAIScanController = MDSAIScanController.init()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
