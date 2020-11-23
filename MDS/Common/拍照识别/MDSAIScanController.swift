//
//  MDSAIScan.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion
class MDSAIScanController: MDSBaseController, AVCapturePhotoCaptureDelegate {
    
    var imgV:UIImageView = UIImageView.init()
    
    //渐变层 --- 扫描动画
    let duration:CGFloat = 3.0
    lazy var gradientLayer: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = self.imgV.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        let color1 = UIColor(red: 61.0/255.0, green: 206.0/225.0, blue: 226.0/255.0, alpha: 1)
        let color2 = UIColorFromRGBAlpha(0xffffff,0.01)
        layer.colors = [color2.cgColor,color2.cgColor,color1.cgColor, color2.cgColor,color2.cgColor]
        layer.locations = [-0.06,-0.01,0,0.01,0.06]
        return layer
    }()
  
    let toolBarH = 64+SAFE_AREA_Height
    //工具栏
    lazy var toolBar:UIView = {
        let temp = UIView.createView(backgroundColor: .black)
        temp.myFrame(0, SCREEN_HEIGHT-self.toolBarH, SCREEN_WIDTH, self.toolBarH)
        let takePhotoBtn = UIButton.init(type: .custom)
        takePhotoBtn.setBackgroundImage(kImage("camera"), for: .normal)
        takePhotoBtn.backgroundColor = .clear
        temp.addSubview(takePhotoBtn)
        takePhotoBtn.addTarget(self, action: #selector(startCamera), for: .touchUpInside)
        takePhotoBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 60, height: 60))
            make.centerY.equalToSuperview().offset(-SAFE_AREA_Height/2)
            make.centerX.equalToSuperview()
        }
        
        let restartBtn = UIView.createBtn(img: kImage("delete"))
        restartBtn.backgroundColor = .clear
        temp.addSubview(restartBtn)
        restartBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        restartBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 22, height: 22))
            make.centerY.equalToSuperview().offset(-SAFE_AREA_Height/2)
            make.left.equalToSuperview().offset(20)
        }
        return temp
    }()
    
    lazy var scanView:MDSScanView = {
        let temp = MDSScanView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-self.toolBarH))
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myNavView.isHidden = true
        self.view.addSubview(self.imgV)
        self.imgV.myFrame(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-toolBarH)
        self.imgV.contentMode = .scaleAspectFill
        self.view.addSubview(self.toolBar)
        self.view.addSubview(self.scanView)
        self.scanView.complete = {[weak self](img)in
            if let pic = img{
                self?.imgV.image = pic
                self?.startAnimation()
                self?.scanView.isHidden = true
                self?.sendData(pic)
            }
        }
    }
    
    func sendData(_ pic:UIImage) {
        //请求数据
        let imgData = UIView.compressImgTohMaxData(origin: pic, maxCount: 2024*2024)
        let base64 = imgData!.base64EncodedString(options: .endLineWithCarriageReturn)
        let params:[String:Any] = ["data":base64]
        //UIImageWriteToSavedPhotosAlbum(pic, self, #selector(self!.image(image:didFinishSavingWithError:contextInfo:)), nil)
        HomeProvider.requsetData(MDSHomeAPI.uploadImgString(params: params)) { (response) -> (Void) in
            if response.isSucces {
                self.stopAnimation()
                print("请求成功")
            }
        }
    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
           if error != nil{
               print("error!")
               return
           }
    }

    
    //扫描动画
    func startAnimation() {
        self.imgV.layer.addSublayer(self.gradientLayer)
        let gradientAnimation: CABasicAnimation = CABasicAnimation()
        gradientAnimation.keyPath = "locations"
        gradientAnimation.fromValue = [-0.06,-0.01,0,0.01,0.06]
        gradientAnimation.toValue = [0.94,0.99,1,1.01,1.06]
        gradientAnimation.duration = 2
        gradientAnimation.repeatCount = 99
        self.gradientLayer.add(gradientAnimation, forKey: "scan");
    }
    
    //扫描动画
    func stopAnimation() {
        self.gradientLayer.removeFromSuperlayer()
        self.gradientLayer.removeAllAnimations()
        self.imgV.layoutIfNeeded()
    }

    @objc func cancelBtnClick(){
        self.stopAnimation()
        self.dismiss(animated: false, completion: nil)
    }
    
    //拍照
    @objc func startCamera(){
        self.scanView.startCamera()
    }
    
}

