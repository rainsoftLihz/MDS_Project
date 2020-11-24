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
import HandyJSON
class MDSAIScanController: MDSBaseController, AVCapturePhotoCaptureDelegate {
    
    var imgV:UIImageView = UIImageView.init()
    
    //渐变层 --- 扫描动画
    let duration:CGFloat = 3.0
    lazy var gradientLayer: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = self.imgV.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        let color1 = UIColor(red: 0/255.0, green: 249/225.0, blue: 0/255.0, alpha: 1)
        let color2 = UIColorFromRGBAlpha(0xfefefe,0.1)
        layer.colors = [UIColor.clear.cgColor,color2.cgColor,color1.cgColor, color2.cgColor,UIColor.clear.cgColor]
        layer.locations = [-0.1,-0.01,0,0.01,0.1]
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
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.backgroundColor = .clear
        temp.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 100, height: 60))
            make.centerY.equalToSuperview().offset(-SAFE_AREA_Height/2)
            make.left.equalToSuperview()
        }
        
        return temp
    }()
    
    lazy var scanView:MDSScanView = {
        let temp = MDSScanView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-self.toolBarH))
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
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
    
    //MARK: ---- 拍照后发送数据
    func sendData(_ pic:UIImage) {
        //请求数据
        let imgData = UIView.compressImgTohMaxData(origin: pic, maxCount: 2*1024*1024)
        let base64 = imgData!.base64EncodedString(options: .endLineWithCarriageReturn)
        let params:[String:Any] = ["data":base64]
        //保存图片方便调试
        UIImageWriteToSavedPhotosAlbum(pic, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        HomeProvider.requsetData(MDSHomeAPI.uploadImgString(params: params)) { (response) -> (Void) in
            
            self.stopAnimation()
            if response.isSucces {
                
                if let tempDataArr = JSONDeserializer<MDSAIModel>.deserializeModelArrayFrom(array: response.data as? [Any]) {
                    for view in self.imgV.subviews{
                        view.removeFromSuperview()
                    }
                    let size:CGSize = pic.size
                    for item in tempDataArr {
                        //获取坐标
                        if let box = item?.box {
                            //获取坐标
                            let framX:CGFloat = CGFloat(box[0])*SCREEN_WIDTH/size.width
                            let framY:CGFloat = CGFloat(box[1])*self.imgV.height/size.height
//                            if framY>self.imgV.height-15{
//                                framY = self.imgV.height-15
//                            }
                            
                            let info = item?.info
                            
                            let lab:UILabel = UIView.createLab(text:"答案:"+(info?.db)!, color: .blue, fontSize: 13)
                            lab.font = kBloldFont(16)
                            
                            let studentlab:UILabel = UIView.createLab(text:"作答:"+(info?.answer)!, color: .blue, fontSize: 13)
                            studentlab.font = kBloldFont(16)
                            
                            var imgV:UIImageView?
                            if info!.label != 2 {
                                let imgStr = info?.label == 0 ? "cuo":"dui"
                                imgV = UIImageView.init(image: kImage(imgStr as NSString))
                                self.imgV.addSubview(imgV!)
                            }
                            if info!.mark!.count == 0{
                                self.imgV.addSubview(lab)
                                self.imgV.addSubview(studentlab)
                                lab.snp.makeConstraints { (make) in
                                    make.left.equalTo(framX)
                                    make.top.equalTo(framY)
                                }
                                studentlab.snp.makeConstraints { (make) in
                                    make.left.equalTo(lab.snp_right).offset(20)
                                    make.top.equalTo(framY)
                                }
                                
                                if info!.label != 2 {
                                    imgV!.snp.makeConstraints { (make) in
                                        make.left.equalTo(studentlab.snp_right).offset(20)
                                        make.centerY.equalTo(studentlab)
                                        make.size.equalTo(CGSize.init(width: 28, height: 28))
                                    }
                                }
                                
                            }else {
                                if info!.label != 2 {
                                    imgV!.snp.makeConstraints { (make) in
                                        make.left.equalTo(framX)
                                        make.top.equalTo(framY)
                                        make.size.equalTo(CGSize.init(width: 28, height: 28))
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    
                    //缩放手势
                    let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(self.pinchView(pinchGestureRecognizer:)))
                    self.imgV.addGestureRecognizer(pinchGesture)

                    //拖拽手势
                    let dragGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.dragView(dragGesture:)))
                    self.imgV.addGestureRecognizer(dragGesture)
                    self.imgV.isUserInteractionEnabled = true
                    
                }
            }else if response.status == 1{
                UIView.showText(response.msg ?? "请求失败")
            }else{
                UIView.showText("请求失败")
            }
        }
    }
    
    //MARK: ---缩放
    @objc func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer) -> (){
        let view = pinchGestureRecognizer.view
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            view?.transform = view!.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale);
            
            pinchGestureRecognizer.scale = 1;
        }
    }
    
    @objc func dragView(dragGesture:UIPanGestureRecognizer){
        let view = dragGesture.view
        //现对于起始点的移动位置
        let Point = dragGesture.translation(in: self.view)
        var rect = view!.frame
        var viewRect = rect.origin
        viewRect.x += Point.x;
        viewRect.y += Point.y;
        rect.origin = viewRect
        self.imgV.frame = rect
        //初始化translation
        dragGesture.setTranslation(CGPoint.init(x: 0, y: 0), in: view)
    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
           if error != nil{
               print("error!")
               return
           }
    }

    
    //MARK: ---- 扫描动画
    func startAnimation() {
        self.imgV.layer.addSublayer(self.gradientLayer)
        let gradientAnimation: CABasicAnimation = CABasicAnimation()
        gradientAnimation.keyPath = "locations"
        gradientAnimation.fromValue = [-0.1,-0.01,0,0.01,0.1]
        gradientAnimation.toValue = [0.9,0.99,1,1.01,1.1]
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
    
    //MARK: ----拍照
    @objc func startCamera(){
        self.scanView.startCamera()
    }
    
}

