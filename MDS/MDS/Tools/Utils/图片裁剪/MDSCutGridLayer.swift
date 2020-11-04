//
//  MDSCutGridLayer.swift
//  MDS
//
//  Created by rainsoft on 2020/10/29.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSCutGridLayer: CALayer {

    //裁剪范围
    var clippingRect:CGRect = CGRect.zero
    //背景色
    var bgColor:UIColor = UIColor.clear
    //线条颜色
    var gridColor:UIColor = UIColor.white
    
    override func draw(in context: CGContext) {
        var rct:CGRect = self.bounds

        //填充色
        context.setFillColor(bgColor.cgColor)
        context.fill(rct)
        
        //截图范围
        context.clear(clippingRect)
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(0.8)
        
        rct = self.clippingRect
        context.beginPath()
        /*
        //画竖线
        let dw:CGFloat = (clippingRect.size.width)/3
        for i:Int in 0..<4 {
            context.move(to: CGPoint.init(x: rct.origin.x+CGFloat(i)*dw, y: rct.origin.y))
            context.addLine(to: CGPoint.init(x: rct.origin.x+CGFloat(i)*dw, y: rct.origin.y+rct.size.height))
        }
        
        //画横线
        let dh:CGFloat = (clippingRect.size.height)/3
        for i:Int in 0..<4 {
            context.move(to: CGPoint.init(x: rct.origin.x, y: rct.origin.y+CGFloat(i)*dh))
            context.addLine(to: CGPoint.init(x: rct.origin.x+rct.size.width, y: rct.origin.y+CGFloat(i)*dh))
        }
         */
        
        context.strokePath()
    }
    
    
}
