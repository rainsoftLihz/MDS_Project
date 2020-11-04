//
//  MDSImgCollectionwCell.swift
//  MDS
//
//  Created by rainsoft on 2020/11/2.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

private let labW:CGFloat = 22

class MDSImgCollectionwCell: UICollectionViewCell {
    //图片半透明效果
    var bkView:UIView = {
        let temp:UIView = UIView.init()
        temp.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        temp.isHidden = true
        return temp
    }()
    var imgV:UIImageView = UIImageView.init()
    var numLab:UILabel = {
        let lab = UIView.createLab(color: .white, fontSize: 11)
        lab.backgroundColor = UIColorFromRGBAlpha(0xf5f5f5,0.8)
        lab.cornerRadius(cornerRadius: labW/2, color: UIColor.white)
        lab.textAlignment = .center
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imgV)
        self.imgV.frame = self.bounds
        self.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.black.cgColor
        self.contentView.addSubview(self.bkView)
        self.addSubview(self.numLab)
        self.bkView.frame = self.bounds
        self.numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.size.equalTo(CGSize.init(width: labW, height: labW))
        }
       
    }
    
    func changeViewBy(_ index:Int,_ selected:Bool)  {
        self.bkView.isHidden = !selected
        if selected {
            //已经选中
            self.numLab.text = String.init(index)
            self.numLab.backgroundColor = .green
        }else{
            self.numLab.text = ""
            self.numLab.backgroundColor = .clear
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
