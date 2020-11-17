//
//  MDSEditImgController.swift
//  MDS
//
//  Created by rainsoft on 2020/10/28.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

typealias SuccessEditBlock = (_ editedImage:UIImage)->Void

class MDSEditImgController: MDSBaseController {
    let bottomH:CGFloat = 49+SAFE_AREA_Height
    lazy var edtView:MDSEditImgView = {
        let temp = MDSEditImgView.init(frame: CGRect.init(x: 0, y: self.myNavView.maxY, width: SCREEN_WIDTH, height: self.view.height-self.myNavView.maxY-bottomH))
        return temp
    }()

    public var _img:UIImage? 

    public var successEditBlock:SuccessEditBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.myNavView.backgroundColor = .black
        self.addTitle(title: "编辑图片")
        self.titleLab.textColor = .white
        self.view.addSubview(self.edtView)
        self.edtView.imgView.image = self._img
        self.addBottomBtn()
        self.view.bringSubviewToFront(self.myNavView)
    }
    
    func addBottomBtn()  {
        let bottomV:UIView = UIView.createView(backgroundColor: .white)
        self.view.addSubview(bottomV)
        bottomV.myFrame(0, SCREEN_HEIGHT-bottomH, SCREEN_WIDTH, bottomH)
        let titleArr:[String] = ["还原","旋转","完成"]
        let btnW:CGFloat = SCREEN_WIDTH/CGFloat(titleArr.count)
        for index in 0..<titleArr.count{
            let str = titleArr[index]
            let tempBtn:UIButton = UIView.createBtn(title: str, titleColor: .black, fontSize: 13)
            tempBtn.myFrame(btnW*CGFloat(index), 0, btnW, bottomV.height)
            tempBtn.tag = index
            bottomV.addSubview(tempBtn)
            tempBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        }
    }
    
    @objc func btnClick(btn:UIButton){
        let index = btn.tag
        if index == 0 {
            self.edtView.setDefault()
        }else if index == 1 {
            self.edtView.inverted()
        }else {
            self.successEditBlock?(self.edtView.drawPictures())
            self.navigationController?.popViewController(animated: true)
        }
    }

}
