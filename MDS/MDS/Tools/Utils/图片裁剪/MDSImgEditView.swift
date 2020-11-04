//
//  MDSImgEditView.swift
//  MDS
//
//  Created by rainsoft on 2020/10/29.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

let kLeftTopCircleView = 0
let kLeftBottomCircleView = 1
let kRightTopCircleView = 2
let kRightBottomCircleView = 3

class MDSImgEditView: UIView {
    
    public var _imgage:UIImage?
    
    //主图片
    var _imageView:UIImageView = UIImageView.init()
    
    //裁剪区域
    var _clippingRect:CGRect?{
        didSet{
            _ltView?.center = self.convert(CGPoint.init(x:_clippingRect!.origin.x, y:_clippingRect!.origin.y), to: _imageView)
            _lbView!.center = self.convert(CGPoint.init(x:_clippingRect!.origin.x, y:_clippingRect!.origin.y+_clippingRect!.size.height), to: _imageView)
            _rtView?.center = self.convert(CGPoint.init(x:_clippingRect!.origin.x+_clippingRect!.size.width, y:_clippingRect!.origin.y), to: _imageView)
            _rbView?.center = self.convert(CGPoint.init(x:_clippingRect!.origin.x+_clippingRect!.size.width, y:_clippingRect!.origin.y+_clippingRect!.size.height), to: _imageView)
            _gridLayer.clippingRect = _clippingRect!;
            self.setNeedsDisplay()
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        _gridLayer.setNeedsDisplay()
    }
    
    //默认裁剪区域占比 0 表示1:1
    var selectClipRatio:CGFloat = 0
    
    //layer
    var _gridLayer:MDSCutGridLayer = MDSCutGridLayer.init()
    //上下左右四个圆圈
    var _ltView:MDSCutCircle?
    var _lbView:MDSCutCircle?
    var _rtView:MDSCutCircle?
    var _rbView:MDSCutCircle?

    
    init(frame: CGRect, img:UIImage) {
        super.init(frame: frame)
        self.backgroundColor = UIColorFromRGB(0x333333)
        _imgage = img
        self.initUI()
    }
    
    func initUI() {
        self.addSubview(_imageView)
        _imageView.image = _imgage
        self.setImageViewFrame()
        _imageView.isUserInteractionEnabled = true
        //拖拽手势
        let dragGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragImageView(dragGesture:)))
        self._imageView.addGestureRecognizer(dragGesture)
        
        //缩放手势
        let pinchGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchView(pinchGestureRecognizer:)))
        self._imageView.addGestureRecognizer(pinchGesture)
        
        /// 图片裁剪
        _gridLayer.frame = self._imageView.bounds
        _gridLayer.bgColor = UIColor.black.withAlphaComponent(0.5)
        _gridLayer.gridColor = UIColor.white;
        _imageView.layer.addSublayer(_gridLayer)
        
        _ltView = self.createCircle(kLeftTopCircleView)
        _lbView = self.createCircle(kLeftBottomCircleView)
        _rtView = self.createCircle(kRightTopCircleView)
        _rbView = self.createCircle(kRightBottomCircleView)
        
        self.setDefaultClicpRect()
    }
    
    func setDefaultClicpRect() {
        var rect:CGRect = _imageView.bounds;
        if (self.selectClipRatio != 0) {
            let W = rect.size.width * self.selectClipRatio;
            let H = rect.size.height * self.selectClipRatio;
            rect.size.height = H
            rect.size.width = W
            rect.origin.x = (_imageView.bounds.size.width - rect.size.width) / 2;
            rect.origin.y = (_imageView.bounds.size.height - rect.size.height) / 2;
        }
        self._clippingRect = rect;
    }
    
    //MARK: ---缩放
    @objc func pinchView(pinchGestureRecognizer:UIPinchGestureRecognizer) -> (){
        let view = pinchGestureRecognizer.view
        if pinchGestureRecognizer.state == .began || pinchGestureRecognizer.state == .changed {
            view?.transform = view!.transform.scaledBy(x: pinchGestureRecognizer.scale, y: pinchGestureRecognizer.scale);
            pinchGestureRecognizer.scale = 1;
        }
    }
    
    //MARK: ---图片宽高适应
    func setImageViewFrame() {
        let maxH = self.height - 100
        let imgW = (_imgage?.size.width)!
        let imgH = (_imgage?.size.height)!
        var w = self.width - 20
        var h = w*imgH/imgW
        if h > maxH {
            h = maxH
            w = h * imgW/imgH
        }
        _imageView.myFrame((self.width - w) * 0.5, (maxH - h) * 0.5 , w, h)
    }
    
    //MARK: ---拖拽图片
    var initialRect:CGRect = CGRect.zero
    var dragging:Bool = false
    @objc func dragImageView(dragGesture:UIPanGestureRecognizer){
        if dragGesture.state == .began {
            let point = dragGesture.location(in: _imageView)
            dragging = ((_clippingRect?.contains(point)) != nil)
            initialRect = _clippingRect!
        }else if dragging {
            let point = dragGesture.translation(in: _imageView)
            let left = min(max(initialRect.origin.x + point.x, 0), _imageView.frame.size.width-initialRect.size.width)
            let top = min(max(initialRect.origin.y + point.y, 0), _imageView.frame.size.height-initialRect.size.height)
            var rct:CGRect = self._clippingRect!
            rct.origin.x = left
            rct.origin.y = top
            self._clippingRect = rct
        }
    }
    
    
    //MARK: --- 创建circle
    func createCircle(_ tag:Int) -> MDSCutCircle {
        let circle = MDSCutCircle.init(frame: CGRect.zero)
        circle.myFrame(0, 0, 50, 50)
        circle.tag = tag
        //拖拽手势
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragCircleView(sender:)))
        circle.addGestureRecognizer(panGesture)
        self.addSubview(circle)
        return circle
    }
    
    //MARK: ---  拖拽circle
    @objc func dragCircleView(sender:UIPanGestureRecognizer){
        
        var point:CGPoint = sender.location(in: self._imageView)
        let dp:CGPoint = sender.translation(in: self._imageView)
        var rct:CGRect = self._clippingRect!
        
        let W = _imageView.width
        let H = _imageView.height
        
        var minX:CGFloat = 0
        var minY:CGFloat = 0
        var maxX:CGFloat = W
        var maxY:CGFloat = H
        
        let ratio = (sender.view?.tag == 1 || sender.view?.tag == 2) ? -self.selectClipRatio : self.selectClipRatio
        switch sender.view?.tag {
            case kLeftTopCircleView:
                maxX = max((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W)
                maxY = max((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H)
                if (ratio != 0) {
                    let y0 = rct.origin.y - ratio * rct.origin.x;
                    let x0 = -y0 / ratio;
                    minX = max(x0, 0);
                    minY = max(y0, 0);
                    
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                    
                    if(-dp.x*ratio + dp.y > 0){
                        point.x = (point.y - y0) / ratio;
                    }else{
                        point.y = point.x * ratio + y0
                    }
                } else {
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                }
                
                rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
                rct.size.height = rct.size.height - (point.y - rct.origin.y);
                rct.origin.x = point.x;
                rct.origin.y = point.y;
                
                break
            case kLeftBottomCircleView:
                maxX = max((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
                minY = max(rct.origin.y + 0.1 * H, 0.1 * H);
                if (ratio != 0) {
                    let y0 = (rct.origin.y + rct.size.height) - ratio*rct.origin.x ;
                    let xh = (H - y0) / ratio;
                    minX = max(xh, 0);
                    maxY = min(y0, H);
                    
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                    
                    if(-dp.x*ratio + dp.y < 0){
                        point.x = (point.y - y0) / ratio;
                    }else{
                        point.y = point.x * ratio + y0;
                    }
                } else {
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                }
                
                rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
                rct.size.height = point.y - rct.origin.y;
                rct.origin.x = point.x;
                break;
            case kRightTopCircleView:
                minX = max(rct.origin.x + 0.1 * W, 0.1 * W);
                maxY = max((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
                
                if (ratio != 0) {
                    let y0 = rct.origin.y - ratio * (rct.origin.x + rct.size.width);
                    let yw = ratio * W + y0;
                    let x0 = -y0 / ratio;
                    maxX = min(x0, W);
                    minY = max(yw, 0);
                    
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                    
                    if(-dp.x*ratio + dp.y > 0){
                        point.x = (point.y - y0) / ratio
                     }else{
                        point.y = point.x * ratio + y0
                     }
                } else {
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                }
                rct.size.width  = point.x - rct.origin.x;
                rct.size.height = rct.size.height - (point.y - rct.origin.y);
                rct.origin.y = point.y;
                break;
            case kRightBottomCircleView:
                minX = max(rct.origin.x + 0.1 * W, 0.1 * W);
                minY = max(rct.origin.y + 0.1 * H, 0.1 * H);
                
                if (ratio != 0) {
                    let y0 = (rct.origin.y + rct.size.height) - ratio * (rct.origin.x + rct.size.width);
                    let yw = ratio * W + y0;
                    let xh = (H - y0) / ratio;
                    maxX = min(xh, W);
                    maxY = min(yw, H);
                    
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                    
                    if(-dp.x*ratio + dp.y < 0){
                        point.x = (point.y - y0) / ratio
                    }else{
                       point.y = point.x * ratio + y0
                    }
                } else {
                    point.x = max(minX, min(point.x, maxX));
                    point.y = max(minY, min(point.y, maxY));
                }
                rct.size.width  = point.x - rct.origin.x;
                rct.size.height = point.y - rct.origin.y;
                break;
           default:
            return
        }
        self._clippingRect = rct
    }
    
    
    //MARK: ---裁剪
    func cutCompletion() -> UIImage {
        let zoomScale:CGFloat = _imageView.width/(_imageView.image?.size.width)!
        var rct:CGRect = _gridLayer.clippingRect
        rct.size.width  /= zoomScale;
        rct.size.height /= zoomScale;
        rct.origin.x    /= zoomScale;
        rct.origin.y    /= zoomScale;
        let origin:CGPoint = CGPoint.init(x:-rct.origin.x, y:-rct.origin.y);
        UIGraphicsBeginImageContextWithOptions(rct.size, false, _imageView.image!.scale)
        _imageView.image?.draw(at: origin)
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return img
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
