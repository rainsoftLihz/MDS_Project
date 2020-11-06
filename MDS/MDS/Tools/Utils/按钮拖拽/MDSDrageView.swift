//
//  MDSDrageView.swift
//  MDS
//
//  Created by rainsoft on 2020/11/2.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

enum DragTargetType {
    case front
    case backend
    case unSelect
}

class MDSDrageView: UIView {

    var title:String = ""
    
    var titleLab:UILabel = UIView.createLab(color: UIColor.black, fontSize: 14)
    
    var bkView:UIView = UIView.createView(backgroundColor: .white)
    
    var titleArr:[String] = []{
        didSet{
            self.subviews.forEach { (view) in
                if view.tag >= 10000{
                   view.removeFromSuperview()
                }
            }
            
            var frameX:CGFloat = 20
            var frameY:CGFloat = 50
            let H:CGFloat = 30
            let space:CGFloat = 20
            for (index,title) in titleArr.enumerated() {
                let lab:UILabel = UIView.createLab(text: title, color: UIColor.blue, fontSize: 14)
                lab.textAlignment = .center
                let w = UIView.calculateWidth(font: UIFont.systemFont(ofSize: 14), text: title)+20
                if frameX+w+space > SCREEN_WIDTH {
                    frameX = 20
                    frameY += H+15
                }
                lab.myFrame(frameX, frameY, w, H)
                frameX += w+space
                lab.cornerRadius(cornerRadius: H/2, color: .blue)
                self.addSubview(lab)
                lab.tag = index+10000
                //添加拖拽手势
                let dragGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(dragView(dragGesture:)))
                lab.isUserInteractionEnabled = true
                lab.addGestureRecognizer(dragGesture)
            }
        }
    }
    
    typealias DragBlock = (String,Int,CGPoint)->Void
    var dragBlock:DragBlock?
    //保存初始坐标---最终还原用
    var dragOriginFrame:CGRect?
    @objc func dragView(dragGesture:UIPanGestureRecognizer){
        
        let view = dragGesture.view

        switch dragGesture.state {
        case .began:
            self.dragOriginFrame = view?.frame
            break
        case .changed:
           //现对于起始点的移动位置
           let Point = dragGesture.translation(in: self);
           var rect = view!.frame
           var viewRect = rect.origin
           viewRect.x += Point.x;
           viewRect.y += Point.y;
           rect.origin = viewRect
           view!.frame = rect
           //初始化translation
           dragGesture.setTranslation(CGPoint.init(x: 0, y: 0), in: view)
            break
        case .ended:
            let tag = view!.tag - 10000
            let window = UIApplication.shared.delegate?.window!!
            let endPoint = dragGesture.location(in: window)
            //转换为坐标系点
            //let endPoint:CGPoint = self.convert(view!.center, to: window)
            if self.frame.contains(endPoint) {
                //还是在本区域----还原坐标
                view?.frame = self.dragOriginFrame!
            }else {
                if tag < self.titleArr.count {
                    self.dragBlock?(self.titleArr[tag],tag,endPoint)
                }
            }
            break
        default:
            break
        }
    }
    

    init(frame:CGRect,type:DragTargetType) {
        super.init(frame: frame)
        self.addSubview(titleLab)
        self.cornerRadius(cornerRadius: 0.5, color: UIColor.red)
        self.layer.masksToBounds = false
        titleLab.myFrame(20, 0, 110, 50)
        switch type {
            case .front:
                self.titleLab.text = "正面内容"
                break
            case .backend:
                self.titleLab.text = "反面内容"
                break
            default:
                self.titleLab.text = "未分配"
                break
       }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
