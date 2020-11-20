//
//  MDSStorke.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import UIKit

class MDSStorkeView: UIView {
    //当前路径
    var currentPath:CGMutablePath?
    //是否擦除
    var isEarse:Bool = false
    
    //存储所有的路径
    var stroks:[MDSStorke] = []
    //画笔颜色
    var lineColor:UIColor = .red {
        didSet{
            self.isEarse = false
        }
    }
    //画笔宽度
    var lineWidth:CGFloat = 5.0{
        didSet{
            self.isEarse = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPath = CGMutablePath()
        let storke:MDSStorke = MDSStorke.init()
        storke.path = currentPath
        storke.blendMode = isEarse ? .destinationIn:.normal
        storke.lineColor = isEarse ? .clear:self.lineColor
        storke.lineWidth = isEarse ? 20:self.lineWidth
        self.stroks.append(storke)
        //进行类  型转化
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        //获取当前点击位置
        let point = touch.location(in:self)
        currentPath?.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //进行类  型转化
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        //获取当前点击位置
        let point = touch.location(in:self)
        currentPath?.addLine(to: point)
        self.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        for storke in self.stroks {
            storke.strokeWithContext(context: context)
        }
    }
    
    //MARK: --- 清屏
    func clearScreen() {
        self.isEarse = false
        self.stroks.removeAll()
        self.setNeedsDisplay()
    }
    

    //MARK: ---  撤消
    func revokeScreen(){
        self.isEarse = false
        self.stroks.removeLast()
        self.setNeedsDisplay()
    }

    //MARK: --- 擦除
    func eraseSreen() {
        self.isEarse = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MDSStorke: NSObject {
    var path:CGMutablePath?
    var blendMode:CGBlendMode = .normal
    var lineWidth:CGFloat = 5.0
    var lineColor:UIColor = .red
    //绘制的方法
    func strokeWithContext(context:CGContext) {
        context.setStrokeColor(self.lineColor.cgColor)
        context.setFillColor(self.lineColor.cgColor)
        context.setBlendMode(self.blendMode)
        context.setLineWidth(self.lineWidth)
        context.setLineJoin(.round)
        context.beginPath()
        context.addPath(path ?? CGMutablePath())
        context.strokePath()
    }
    
}
