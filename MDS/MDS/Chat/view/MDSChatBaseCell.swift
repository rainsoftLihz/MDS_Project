//
//  MDSChatBaseCell.swift
//  MDS
//
//  Created by rainsoft on 2019/2/25.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

protocol ChatCellDelegate:NSObjectProtocol{
    func actionWithImgClick(backModel:MDSChatModel,cell:MDSChatBaseCell);
}

class MDSChatBaseCell: UITableViewCell {
    
    //定义block
    typealias ClickBlock = ()->()
    //创建block
    var clickBack:ClickBlock!;
    
    //定义代理对象
    public weak var delegate:ChatCellDelegate?
    
    
    //MARK:setter方法
    @objc public var chatModel:MDSChatModel?{
        didSet{
            guard chatModel != nil else {
                return;
            }
            self.reloadUI();
        }
    }
    
    //返回model后设置UI布局  子类重写
    public func reloadUI() {
        
        //内容
        if self.chatModel?.type == .MessageBodyTypeText {
            //计算文字高度
            let (attrStr,size) = self.fommatTextAndCheckSize(str: self.chatModel?.content ?? "");
            if size.height < 30 {
                //单行
                self.contentLab.text = self.chatModel?.content;
            }else {
               self.contentLab.attributedText = attrStr;
            }
            
        }else if self.chatModel?.type == .MessageBodyTypeImage {
            
        }
        
        //bubble图片
    
        var bubImg:UIImage?;
    
        if self.chatModel?.isMine == false {
            bubImg = UIImage(named: "IM_Chat_sender_bg");
            self.iconImg.image = UIImage(named: "xkdj");
        }else {
            bubImg = UIImage(named: "IM_Chat_receiver_bg");
            self.iconImg.image = UIImage(named: "IM_Chat_sender_bg");
        }
        
        //拉伸图片
        self.bubbleImg.image = bubImg?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), resizingMode: .stretch);
        
    }
    
    //计算富文本文字高度
    func fommatTextAndCheckSize(str:String) -> (NSMutableAttributedString,CGSize) {
        let paragraph:NSMutableParagraphStyle = NSMutableParagraphStyle();
        paragraph.lineSpacing = 10.0;
        
        let mutabStr:NSMutableAttributedString = NSMutableAttributedString(string: str, attributes:                    [NSAttributedString.Key.font:self.contentLab.font,NSAttributedString.Key.paragraphStyle:paragraph]);
      
        let size:CGSize = mutabStr.boundingRect(with: CGSize(width: SCREEN_WIDTH-200, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).size;
        return (mutabStr,size);
    }
    
    
    
    
    //MARK:初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.contentView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        self.selectionStyle = .none;
        self.setUpUI();
    }
    
    
    
    func setUpUI()  {
        self.contentView.addSubview(self.bubbleImg);
        self.contentView.addSubview(self.iconImg);
        self.bubbleImg.addSubview(self.contentImg);
        self.bubbleImg.addSubview(self.contentLab);
        
        //点击事件
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bubClick));
        self.bubbleImg.addGestureRecognizer(tap);

        
    }
    
    
    //文字
    public var contentLab:QMUILabel = {
        let lab = QMUILabel();
        lab.font = UIFont.systemFont(ofSize: 14.0);
        lab.textColor = UIColor.red;
        lab.numberOfLines = 0;
        return lab;
    }();
    
    //气泡
    public var bubbleImg:UIImageView = {
        let img = UIImageView();
        img.isUserInteractionEnabled = true;
        return img;
    }();
    
    //MARK:气泡点击
    @objc func bubClick()  {
        NSLog("T##format: String##St");
        if let _ = clickBack{
            clickBack();
        }
    }
    
    //图片
    public var contentImg:UIImageView = {
        let img = UIImageView();
        return img;
    }();
    
    //icon图片
    public var iconImg:UIImageView = {
        let img = UIImageView();
        img.layer.masksToBounds = true;
        img.layer.cornerRadius = 22.0;
        return img;
    }();
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
