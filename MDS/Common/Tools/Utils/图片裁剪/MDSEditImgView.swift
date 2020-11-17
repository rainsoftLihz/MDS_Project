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
    let clipRect:CGRect = CGRect.init(x: SCREEN_WIDTH/2-175, y: 100, width: 350, height: 350)
    
    public var targetView : MDSCutAreaView = MDSCutAreaView.init()
    //layer
    var _gridLayer:MDSCutGridLayer = MDSCutGridLayer.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(targetView)
        self.targetView.addSubview(imgView)
        self.imgView.isUserInteractionEnabled = true
        self.targetView.frame = clipRect
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.frame = self.targetView.bounds
        self.targetView.delegate = self
        self.targetView.backgroundColor = .clear
        self.addLayer()
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
    
    
    func addLayer() {
        _gridLayer.frame = self.bounds
        _gridLayer.bgColor = UIColor.black.withAlphaComponent(0.5)
        _gridLayer.clippingRect = clipRect
        self.layer.addSublayer(_gridLayer)
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .black
        self._gridLayer.setNeedsDisplay()        
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
        }
    }
    
    //MARK: --- 还原图片
    func setDefault(){
        self.imgView.transform = CGAffineTransform.identity
        self.imgView.frame = self.targetView.bounds
    }
    
    //MARK: ---编辑过后生成图片
    func drawPictures() -> UIImage {
        return UIView.getImageFromView(view: self.targetView)!
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
