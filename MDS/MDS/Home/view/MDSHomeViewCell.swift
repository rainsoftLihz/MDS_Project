//
//  MDSHomeViewCell.swift
//  MDS
//
//  Created by rainsoft on 2019/3/5.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSHomeViewCell: UICollectionViewCell {
    
    let btnH:CGFloat = 34.0
    
    lazy var titleLab:UILabel = {
        let titleLab = self.createLab(color: .black, fontSize: 14)
        titleLab.numberOfLines = 2
        return titleLab
    }()
    
    lazy var classLab:UILabel = {
        let classLab = self.createLab(color: .lightGray, fontSize: 12)
        return classLab
    }()
    
    lazy var timeLab:UILabel = {
        let tempLab = self.createLab(text: "", color: .blue, fontSize: 12,alignment: .center)
        return tempLab
    }()
    
    lazy var pgBtn:UIButton = {
        let temp = self.createBtn(title: "去批阅", titleColor: .black, fontSize: 14)
        temp.cornerRadius(cornerRadius: CGFloat(self.btnH/2))
        return temp
    }()
    
    lazy var printBtn:UIButton = {
        let temp = self.createBtn(title: "打印痕迹", titleColor: .black, fontSize: 14)
        temp.cornerRadius(cornerRadius: CGFloat(self.btnH/2))
        return temp
    }()
    
    var model: MDSHomeModel?{
        didSet{
            guard let model = model else {return}
            self.titleLab.text = model.homeworkName
            self.timeLab.text = model.scanTime
            self.classLab.text = model.className
            
            if model.printStatus == 0 {
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColorFromRGB(0xf6f6f6)
        let bgView = self.createView(backgroundColor: .white)
        bgView.cornerRadius(cornerRadius: 3.0)
        self.addSubViews([bgView,timeLab])
        bgView.addSubViews([titleLab,pgBtn,classLab,printBtn])
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLab.snp_bottom)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        timeLab.snp.makeConstraints { (make) in
            make.top.right.leading.equalToSuperview()
            make.height.equalTo(30)
        }
        
        
        titleLab.snp.makeConstraints { (make) in
            make.top.leading.equalTo(10)
            make.right.equalTo(-10)
        }
        
        classLab.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp_bottom).offset(10)
            make.right.equalTo(-10)
            make.left.equalTo(titleLab)
        }
        
        let btnSpace:Int = 10
        let btnW:Float = 90.0
        
        pgBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-btnSpace)
            make.height.equalTo(btnH)
            make.width.equalTo(btnW)
        }
        
        printBtn.snp.makeConstraints{ (make) in
            make.bottom.equalTo(-btnSpace)
            make.right.equalTo(pgBtn.snp_left).offset(-btnSpace)
            make.height.equalTo(btnH)
            make.width.equalTo(btnW)
        }
    }
    
    
    
    class func identer() -> String{
        return "MDSHomeViewCell";
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
