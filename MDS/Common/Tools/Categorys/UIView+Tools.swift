//
//  UIView+Tools.swift
//  MDS
//
//  Created by rainsoft on 2020/10/23.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

let borderWidth:CGFloat = 0.8

enum UIRectCornerType {
    case UIRectCornerTopLeft,
    UIRectCornerTopRight,
    UIRectCornerBottomLeft,
    UIRectCornerBottomRight,
    UIRectCornerAll
    func corner() -> UIRectCorner {
        switch self {
        case .UIRectCornerTopRight:
            return UIRectCorner.topRight
        case .UIRectCornerTopLeft:
            return UIRectCorner.topLeft
        case .UIRectCornerBottomRight:
            return UIRectCorner.bottomRight
        case .UIRectCornerBottomLeft:
            return UIRectCorner.bottomLeft
        default:
            return UIRectCorner.allCorners
        }
    }
}

typealias TapBlock = ()->Void

extension UIView{
    
    var tapBlock: TapBlock? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.ClickBlockKey!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            return  (objc_getAssociatedObject(self, RuntimeKey.ClickBlockKey!) as! TapBlock)
        }
    }
    
    //MARK: ---点击事件
    func tapAction(block:@escaping TapBlock) {
        self.tapBlock = block
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognizer))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureRecognizer(){
        self.tapBlock!()
    }
    
    //MARK: --- 计算文字宽度高度
    static func calculateWidth(font: UIFont ,text : String) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    static func calculateHeight(font: UIFont ,text : String) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    static func calculateSize(font: UIFont ,text : String) -> CGSize {
        let constraintRect = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let boundingBox = text.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size
    }
    
    //MARK: --- UIImage压缩
    
    public class func compressImgTohMaxData(origin:UIImage,maxCount:Int) -> Data? {
        
        var compression:CGFloat = 1
        
        guard var data = origin.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        if data.count <= maxCount {
            return data
        }
        
        var max:CGFloat = 1,min:CGFloat = 0.8//最小0.8
        
        for i in 0..<6 {//最多压缩6次
            
            compression = (max+min)/2
            
            if let tmpdata = origin.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
            if data.count <= maxCount {
                
                return data
                
            } else {
                
                max = compression
                
            }
            
        }
        
        //压缩分辨率
        guard var resultImage = UIImage(data: data) else { return nil }
        
        var lastDataCount:Int = 0
        
        while data.count > maxCount && data.count != lastDataCount {
            
            lastDataCount = data.count
            
            let ratio = CGFloat(maxCount)/CGFloat(data.count)
            
            let size = CGSize(width: resultImage.size.width*sqrt(ratio), height: resultImage.size.height*sqrt(ratio))
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(Int(size.width)), height: CGFloat(Int(size.height))), true, 1)//防止黑边
            
            resultImage.draw(in: CGRect(origin: .zero, size: size))//比转成Int清晰
            
            if let tmp = UIGraphicsGetImageFromCurrentImageContext() {
                
                resultImage = tmp
                
                UIGraphicsEndImageContext()
                
            } else {
                
                UIGraphicsEndImageContext()
                
                return nil
            }
            
            if let tmpdata = resultImage.jpegData(compressionQuality: compression) {
                
                data = tmpdata
                
            } else {
                
                return nil
                
            }
            
        }
        
        return data
    }
    
    func resizeAndCompressImageToData(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat, compressionQuality: CGFloat) -> Data? {
        
        let horizontalRatio = maxWidth / image.size.width
        let verticalRatio = maxHeight / image.size.height
        
        
        let ratio = min(horizontalRatio, verticalRatio)
        
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        let data = newImage.jpegData(compressionQuality: compressionQuality)
        
        
        
        return data
        
    }
    
    func resizeAndCompressToImage(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat, compressionQuality: CGFloat) -> UIImage? {
        
        let horizontalRatio = maxWidth / image.size.width
        let verticalRatio = maxHeight / image.size.height
        
        let ratio = min(horizontalRatio, verticalRatio)
        
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        var newImage: UIImage
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    //MARK: - UIView转UIImage
    static func getImageFromView(theView: UIView,rect: CGRect) ->UIImage?{
        UIGraphicsBeginImageContextWithOptions(theView.frame.size,false, UIScreen.main.scale);
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState();
        
        UIRectClip(rect);
        theView.layer.render(in: context)
        let theImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil)
        return theImage
    }
    
    //MARK: - UIView转UIImage
    static func getImageFromView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: ----addSubView
    func addSubViews(_ views:[UIView])  {
        for item in views {
            self.addSubview(item)
        }
    }
    
    //MARK: ----cornerRadius
    func cornerRadius(cornerRadius:CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func cornerRadius(cornerRadius:CGFloat,corner:UIRectCorner) {
        let maskPath:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
        let layer:CAShapeLayer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.path = maskPath.cgPath
        self.layer.mask = layer
        self.layer.masksToBounds = true
    }
    
    func cornerRadius(cornerRadius:CGFloat,color:UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
    }
    
    //MARK: ----frame
    func myFrame(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat) {
        self.frame = CGRect.init(x: x, y: y, width: w, height: h)
    }
    
    public var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    public var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    public var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    public var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
}
