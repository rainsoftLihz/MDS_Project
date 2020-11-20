//
//  MDSStoreController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
class MDSStoreController: MDSBaseController,UIScrollViewDelegate {
    
    lazy var scrollView:UIScrollView = {
        let temp = UIScrollView.init(frame: CGRect.zero)
        temp.myFrame(0, self.myNavView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.myNavView.maxY)
        temp.contentSize = CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT*1.4)
        temp.delegate = self
        return temp
    }()
    
    lazy var storkeView:MDSStorkeView = {
        let temp = MDSStorkeView.init(frame: CGRect.zero)
        temp.myFrame(0, self.myNavView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.myNavView.maxY)
        return temp
    }()
    
    var  flag:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "画板大讲堂")
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.storkeView)
        let imv1 = UIImageView.init(image: kImage("banner_1"))
        imv1.myFrame(0, 0, SCREEN_WIDTH, 500)
        
        let imv2 = UIImageView.init(image: kImage("banner_2"))
        imv2.myFrame(0, 500, SCREEN_WIDTH, 500)
        self.scrollView.addSubViews([imv1,imv2])
        self.scrollView.bringSubviewToFront(self.storkeView)
        
        
        let btn = UIButton.init(frame: CGRect.init(x: 10, y: 100, width: 100, height: 100))
        self.view.addSubview(btn)
        btn.backgroundColor = .black
        btn.setTitle("清除痕迹", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        let btn1 = UIButton.init(frame: CGRect.init(x: 10, y: 210, width: 100, height: 100))
        self.view.addSubview(btn1)
        btn1.backgroundColor = .black
        btn1.setTitle("铅笔擦", for: .normal)
        btn1.addTarget(self, action: #selector(btn1Click), for: .touchUpInside)
        
        let btn2 = UIButton.init(frame: CGRect.init(x: 10, y: 210, width: 100, height: 100))
        self.view.addSubview(btn2)
        btn2.backgroundColor = .black
        btn2.setTitle("撤销", for: .normal)
        btn2.addTarget(self, action: #selector(btn2Click), for: .touchUpInside)
        
        self.scrollView.isScrollEnabled = false
        self.storkeView.isUserInteractionEnabled = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.storkeView.clearScreen()
    }
    
    @objc func btnClick(){
        self.scrollView.isScrollEnabled = !self.flag
        self.storkeView.isUserInteractionEnabled = self.flag
        self.flag = !self.flag
    }
    
    @objc func btn1Click(){
        self.storkeView.eraseSreen()
    }
    
    @objc func btn2Click(){
        self.storkeView.revokeScreen()
    }
}
