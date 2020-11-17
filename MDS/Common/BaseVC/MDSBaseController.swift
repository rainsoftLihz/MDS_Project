//
//  MDSBaseController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSBaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.myNavView)
        self.view.backgroundColor = UIColorFromRGB(0xf6f6f6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: --- 自定义nav
       lazy var myNavView:UIView = {
           let nav = UIView.createView(backgroundColor: .white)
           nav.myFrame(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT)
           return nav
       }()
       
       lazy var titleLab:UILabel = {
           let temp = UILabel.init()
           temp.textAlignment = .center
           temp.textColor = .black
           temp.font = kBloldFont(18)
           return temp
       }()
       
       lazy var leftBtn:UIButton = {
           let temp = UIButton.init(type: .custom)
           temp.frame = CGRect.init(x: 15, y: STATUS_BAR_Height, width: 60, height: NAV_BAR_HEIGHT-STATUS_BAR_Height)
           temp.backgroundColor = .clear
           temp.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
           temp.contentHorizontalAlignment = .left
           return temp
       }()
       
       lazy var rightBtn:UIButton = {
           let temp = UIButton.init(type: .custom)
           temp.frame = CGRect.init(x: SCREEN_WIDTH - 70, y: STATUS_BAR_Height, width: 60, height: NAV_BAR_HEIGHT-STATUS_BAR_Height)
           temp.backgroundColor = .clear
           temp.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
           temp.contentHorizontalAlignment = .right
           return temp
       }()
    
    @objc func backBtnClick() {
        self.navigationController?.popViewController(animated: false);
    }
    
    @objc func rightBtnClick(){
        
    }
    
    deinit {
        NSLog("%@ 销毁了。。。。。", NSStringFromClass(object_getClass(self)!));
    }
}

extension MDSBaseController {
    
    func addTitle(title: String?){
        self.titleLab.removeFromSuperview()
        self.titleLab.text = title
        self.myNavView.addSubview(self.titleLab)
        self.titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(STATUS_BAR_Height)
            make.height.equalTo(NAV_BAR_HEIGHT-STATUS_BAR_Height)
        }
    }
    
    func addTitleView(view: UIView?){
        self.titleLab.removeFromSuperview()
        self.myNavView.addSubview(view!)
        let size:CGSize = (view?.frame.size)!
        if size.equalTo(CGSize.zero) {
            view?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(self.myNavView.snp_centerY).offset(STATUS_BAR_Height/2)
            })
        }else {
            view?.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalTo(self.myNavView.snp_centerY).offset(STATUS_BAR_Height/2)
                make.size.equalTo(size)
            })
        }
    }
    
    func addBackNav(image: UIImage?){
        self.leftBtn.removeFromSuperview()
        self.leftBtn.setImage(image, for: .normal)
        self.leftBtn.setImage(image, for: .highlighted)
        self.myNavView.addSubview(self.leftBtn)
    }
    
    func addLeftNav(title: String?){
        self.leftBtn.removeFromSuperview()
        self.leftBtn.setTitle(title, for: .normal)
        self.myNavView.addSubview(self.leftBtn)
    }
    
    func addRightNav(image: UIImage?){
        self.rightBtn.removeFromSuperview()
        self.rightBtn.setImage(image, for: .normal)
        self.rightBtn.setImage(image, for: .highlighted)
        self.myNavView.addSubview(self.rightBtn)
    }
    
    func addRightNav(title: String?){
        self.rightBtn.removeFromSuperview()
        self.rightBtn.setTitle(title, for: .normal)
        self.myNavView.addSubview(self.rightBtn)
    }
    
}

