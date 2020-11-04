//
//  UIView+Factory.swift
//  MDS
//
//  Created by rainsoft on 2020/10/23.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

extension UIView {

//网络加载
    public class func showHud(){
        SVProgressHUD.show()
    }
    
    public class func dismissHud(){
        SVProgressHUD.dismiss()
    }
    
    public class func showSuccessText(_ text:String){
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    public class func showErrorText(_ text:String){
        SVProgressHUD.showError(withStatus: text)
    }
    
    public class func showTipsText(_ text:String){
        SVProgressHUD.showInfo(withStatus: text)
    }
    
    
//MARK: ---Lab
    public class func createLab(color:UIColor,fontSize:CGFloat) -> UILabel {
        return self.createLab(text:"", color: color, fontSize: fontSize, alignment: .left)
    }
    
    public class func createLab(text:String,color:UIColor,fontSize:CGFloat) -> UILabel {
        return self.createLab(text:text, color: color, fontSize: fontSize, alignment: .left)
    }
    
    public class func createLab(text:String,color:UIColor,fontSize:CGFloat,alignment:NSTextAlignment) -> UILabel {
        let tempLab = UILabel.init()
        tempLab.text = text
        tempLab.textColor = color
        tempLab.textAlignment = alignment
        tempLab.font = UIFont.systemFont(ofSize: fontSize)
        return tempLab
    }
    
//MARK: ---Btn
    public class func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat) -> UIButton {
        return self.createBtn(title: title, titleColor: titleColor, fontSize: fontSize, img: nil)
    }
    
    public class func createBtn(img:UIImage?) -> UIButton {
        let tempBtn = UIButton.init(type: .custom)
        tempBtn.setImage(img, for: .normal)
        tempBtn.setImage(img, for: .highlighted)
        return tempBtn
    }
    
    public class func createBtn(title:String,titleColor:UIColor,fontSize:CGFloat,img:UIImage?) -> UIButton {
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
    public class func createTextF(placeHolder:String,color:UIColor,fontSize:CGFloat) -> UITextField {
        let tempTF = UITextField.init()
        tempTF.placeholder = placeHolder
        tempTF.font = UIFont.systemFont(ofSize: fontSize)
        tempTF.textColor = color
        return tempTF
    }
    
    public class func createTextF(placeHolder:String,holderColor:UIColor,color:UIColor,fontSize:CGFloat) -> UITextField {
        let tempTF = UITextField.init()
        tempTF.font = UIFont.systemFont(ofSize: fontSize)
        tempTF.textColor = color
        let pholder = NSAttributedString.init(string: placeHolder, attributes: [.foregroundColor:holderColor,.font:UIFont.systemFont(ofSize: fontSize)])
        tempTF.attributedPlaceholder = pholder
        return tempTF
    }
    
//MARK: ---view
    public class func createView(backgroundColor:UIColor) -> UIView {
        let tempView = UIView.init()
        tempView.backgroundColor = backgroundColor
        return tempView
    }
}
