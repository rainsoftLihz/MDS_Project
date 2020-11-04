//
//  MDSCutCircle.swift
//  MDS
//
//  Created by rainsoft on 2020/10/29.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
/**
裁剪网格的4个角 （圆球）。可以和KKscaleButton合并，看需求
*/
class MDSCutCircle: UIView {
    
    let bgColor:UIColor = UIColorFromRGB(0x41bdff)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        var rct = self.bounds
        rct.origin.x = rct.size.width/2 - rct.size.width/6
        rct.origin.y = rct.size.height/2 - rct.size.height/6
        rct.size.width /= 3
        rct.size.height /= 3
        context?.setFillColor(bgColor.cgColor)
        context?.fillEllipse(in: rct)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
