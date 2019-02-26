//
//  MDSChatNotMineCell.swift
//  MDS
//
//  Created by rainsoft on 2019/2/25.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSChatNotMineCell: MDSChatBaseCell {

    override func setUpUI() {
        super.setUpUI();
        //布局
        self.iconImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(10.0);
            make.top.equalTo(self.contentView.snp.top).offset(10.0)
            make.size.equalTo(CGSize(width: 44.0, height: 44.0))
        }
        
        self.bubbleImg.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImg.snp.right).offset(10.0);
            make.top.equalTo(self.iconImg.snp.top).offset(0.0)
        }
        
        self.contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.bubbleImg.snp.left).offset(10.0);
            make.top.equalTo(self.bubbleImg.snp.top).offset(10.0);
            make.right.equalTo(self.bubbleImg.snp.right).offset(-10.0);
            make.bottom.equalTo(self.bubbleImg.snp.bottom).offset(-10);
        }
        
        self.bubbleImg.snp.makeConstraints{ (make) in
            make.top.equalTo(self.iconImg.snp.top);
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-10.0);
            make.width.lessThanOrEqualTo(SCREEN_WIDTH-150);
        }
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconClick));
        self.iconImg.addGestureRecognizer(tap);
        self.iconImg.isUserInteractionEnabled = true;
    }

    @objc func iconClick() {
        if (self.delegate != nil) {
            self.delegate?.actionWithImgClick(backModel: self.chatModel!,cell:self);
        }
    }

    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
