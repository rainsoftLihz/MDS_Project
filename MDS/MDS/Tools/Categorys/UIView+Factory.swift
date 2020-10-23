//
//  UIView+Factory.swift
//  MDS
//
//  Created by rainsoft on 2020/10/23.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

extension NSObject {

//网络加载
    public class func showHud(){
        SVProgressHUD.show()
    }
    
    public class func dismissHud(){
        SVProgressHUD.dismiss()
    }
    
    public class func showText(_ text:String){
        SVProgressHUD.showInfo(withStatus: text)
    }
    
    
//MARK: ---Lab
    func createLab(color:UIColor,fontSize:CGFloat) -> UILabel {
        return self.createLab(text:"", color: color, fontSize: fontSize, alignment: .left)
    }
    
    func createLab(text:String,color:UIColor,fontSize:CGFloat) -> UILabel {
        return self.createLab(text:text, color: color, fontSize: fontSize, alignment: .left)
    }
    
    func createLab(text:String,color:UIColor,fontSize:CGFloat,alignment:NSTextAlignment) -> UILabel {
        let tempLab = UILabel.init()
        tempLab.text = text
        tempLab.textColor = color
        tempLab.textAlignment = alignment
        tempLab.font = UIFont.systemFont(ofSize: fontSize)
        return tempLab
    }
    
//MARK: ---Btn
    func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat) -> UIButton {
        return self.createBtn(title: title, titleColor: titleColor, fontSize: fontSize, img: nil)
    }
    
    func createBtn(img:UIImage?) -> UIButton {
        let tempBtn = UIButton.init(type: .custom)
        tempBtn.setImage(img, for: .normal)
        tempBtn.setImage(img, for: .highlighted)
        return tempBtn
    }
    
    func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat,img:UIImage?) -> UIButton {
        let tempBtn = UIButton.init(type: .custom)
        tempBtn.setTitle(title, for: .normal)
        tempBtn.setTitleColor(titleColor, for: .normal)
        tempBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        if img != nil {
            tempBtn.setImage(img, for: .normal)
        }
        return tempBtn
    }
    
//MARK: ---textF
    func createTextF(placeHolder:String,color:UIColor,fontSize:CGFloat) -> UITextField {
        let tempTF = UITextField.init()
        tempTF.placeholder = placeHolder
        tempTF.font = UIFont.systemFont(ofSize: fontSize)
        tempTF.textColor = color
        return tempTF
    }
    
    func createTextF(placeHolder:String,holderColor:UIColor,color:UIColor,fontSize:CGFloat) -> UITextField {
        let tempTF = UITextField.init()
        tempTF.font = UIFont.systemFont(ofSize: fontSize)
        tempTF.textColor = color
        let pholder = NSAttributedString.init(string: placeHolder, attributes: [.foregroundColor:holderColor,.font:UIFont.systemFont(ofSize: fontSize)])
        tempTF.attributedPlaceholder = pholder
        return tempTF
    }
    
//MARK: ---view
    func createView(backgroundColor:UIColor) -> UIView {
        let tempView = UIView.init()
        tempView.backgroundColor = backgroundColor
        return tempView
    }
}
