//
//  MDSCutAreaView.swift
//  MDS
//
//  Created by rainsoft on 2020/10/30.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

public protocol MDSCutAreaViewDelegate : NSObjectProtocol {
    func actionView() -> UIView
}

class MDSCutAreaView: UIView {
    var delegate: MDSCutAreaViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    //手势事件都转移到其它视图
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.delegate?.actionView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
