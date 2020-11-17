//
//  MDSMinewController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSMinewController: MDSBaseController,MDSChoseImgsToolDelegate {
    
    var choseBtn:UIButton = UIView.createBtn(title: "选择图片", titleColor: .black, fontSize: 14)
    
    var imgV:UIImageView = {
        let w:CGFloat = 350
        let tempV:UIImageView = UIImageView.init(frame: CGRect.init(x: SCREEN_WIDTH/2-w/2, y: 150, width: w, height: w))
        tempV.image = UIImage.init(named: "xkdj")
        tempV.backgroundColor = .yellow
        tempV.contentMode = .scaleAspectFill
        return tempV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubViews([choseBtn,imgV])
        choseBtn.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
        choseBtn.addTarget(self, action: #selector(choseImg), for: .touchUpInside)
        
    }
    
    func didTakePhohtoBack(img: UIImage) {
//        let vc:MDSBrowsePhotoController = MDSBrowsePhotoController.init()
//        vc.imgArr = [img]
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc:MDSEditImgController = MDSEditImgController.init()
        vc._img = img
        vc.successEditBlock = {[weak self] (img) in
            self!.imgV.image = img
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectPhohtosBack(imgArr: [UIImage]) {
//        let vc:MDSBrowsePhotoController = MDSBrowsePhotoController.init()
//        vc.imgArr = imgArr
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let vc:MDSEditImgController = MDSEditImgController.init()
        vc._img = imgArr.first
        vc.successEditBlock = {[weak self] (img) in
            self!.imgV.image = img
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func choseImg(){
        MDSChoseImgsTool.manger.choseImg(superVC: self)
    }
}
