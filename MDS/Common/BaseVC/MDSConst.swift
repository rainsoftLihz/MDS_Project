//
//  MDSConst.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

import SnapKit

import Alamofire

import Kingfisher

import HandyJSON

//Mark --- 尺寸
//屏幕宽度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width

//屏幕高度
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

let IS_IPHONE:Bool = (UIDevice.current.model == "iPhone")

let Is_Iphone_X =  (IS_IPHONE && (SCREEN_HEIGHT - 812 >= 0.0 || SCREEN_WIDTH - 812 >= 0.0))

/** 底部安全区域高度 */
let SAFE_AREA_Height:CGFloat = Is_Iphone_X ? 34: 0
/** 状态栏区域高度 */
let  STATUS_BAR_Height:CGFloat = Is_Iphone_X ? 44 : 20
// 内容区高度：屏幕高度 - 状态栏 - 导航栏 高度
let NAV_BAR_HEIGHT:CGFloat = Is_Iphone_X ? 88 : 64
//UITabBar高度
let TAB_BAR_HEIGHT:CGFloat = Is_Iphone_X ? 83 : 49

// MARK: 设置颜色
/// 通过 十六进制与alpha来设置颜色值  （ 样式： 0xff00ff ）
public let HexRGBAlpha:((Int,Float) -> UIColor) = { (rgbValue : Int, alpha : Float) -> UIColor in
    return UIColor(red: CGFloat(CGFloat((rgbValue & 0xFF0000) >> 16)/255), green: CGFloat(CGFloat((rgbValue & 0xFF00) >> 8)/255), blue: CGFloat(CGFloat(rgbValue & 0xFF)/255), alpha: CGFloat(alpha))
}
/// 设置颜色值
public let UIColorFromRGB:((Int) -> UIColor) = { (rgbValue : Int) -> UIColor in
    return HexRGBAlpha(rgbValue,1.0)
}

public let UIColorFromRGBAlpha:((Int , Float) -> UIColor) = { (rgbValue:Int,alpha:Float) -> UIColor in
    return HexRGBAlpha(rgbValue,alpha)
}

// MARK: --- UI
public let kFont:((CGFloat) -> UIFont) = { (s : CGFloat) -> UIFont in
    return UIFont.systemFont(ofSize: s)
}

public let kBloldFont:((CGFloat) -> UIFont) = { (s : CGFloat) -> UIFont in
    return UIFont.boldSystemFont(ofSize: s)
}

public let kImage:((String) -> UIImage) = { (s : String) -> UIImage in
    return UIImage.init(named: s as String) ?? UIImage.init()
}

