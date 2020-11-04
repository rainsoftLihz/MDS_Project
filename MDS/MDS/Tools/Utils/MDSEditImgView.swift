//
//  MDSEditImgView.swift
//  MDS
//
//  Created by rainsoft on 2020/10/28.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSEditImgView: UIView,MDSCutAreaViewDelegate{

    //设置图片
    public var imgView: UIImageView = UIImageView()
    //截取区域
    public var targetView : MDSCutAreaView = MDSCutAreaView.init(frame: CGRect.init(x: 10, y: 100, width: 100, height: 100))
    //透明背景
    public var cropView: MDSCutAreaView = MDSCutAreaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.addSubview(self.cropView)
        self.addSubview(targetView)
        self.targetView.addSubview(imgView)
        //cropView.addSubview(imgView)
        imgView.isUserInteractionEnabled = true
        targetView.myFrame(SCREEN_WIDTH/2-175, 100, 350, 350)
        imgView.myFrame(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)
        //cropView.center = targetView.center
        imgView.center = targetView.center
        self.cropView.delegate = self
        self.targetView.delegate = self
        
        self.targetView.backgroundColor = .clear
        self.targetView.layer.borderWidth = 1
        self.targetView.layer.borderColor = UIColor.white.cgColor
        
        //缩放手势
        let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchView(pinchGestureRecognizer:)))
        self.imgView.addGestureRecognizer(pinchGesture)

        //拖拽手势
        let dragGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragView(dragGesture:)))
        self.imgView.addGestureRecognizer(dragGesture)
    }
    
    func actionView() -> UIView {
        return self.imgView
    }
    
    override func draw(_ rect: CGRect) {
        self.imgView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.cropView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
    }

    @objc func dragView(dragGesture:UIPanGestureRecognizer){
        let view = dragGesture.view
        //现对于起始点的移动位置
        let Point = dragGesture.translation(in: self);
        var rect = view!.frame
        var viewRect = rect.origin
        viewRect.x += Point.x;
        viewRect.y += Point.y;
        rect.origin = viewRect
        imgView.frame = rect
        //初始化translation
        dragGesture.setTranslation(CGPoint.init(x: 0, y: 0), in: view)
    }
    
    //MARK: ---缩放
    @objc func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer) -> (){
        let view = pinchGestureRecognizer.view
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            view?.transform = view!.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale);
            
            pinchGestureRecognizer.scale = 1;
        }
    }
    
    
    //MARK: ---旋转
    func inverted(){
        
        UIView.animate(withDuration: 0.2) {
            self.imgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2).concatenating(self.imgView.transform)
            //self.imgView.center = self.targetView.center
        }
    }
    
    //MARK: --- 还原图片
    func setDefault(){
        self.imgView.transform = CGAffineTransform.identity
//        let rect = self.cropView.frame
//        self.cropView.myFrame(0, 0, rect.width, rect.height)
    }
    
    //MARK: ---编辑过后生成图片
    func drawPictures() -> UIImage {

        _ = self.convert(self.targetView.frame, to: self.cropView)
        return UIView.getImageFromView(view: self.targetView)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
