//
//  MDSChatModel.swift
//  MDS
//
//  Created by rainsoft on 2019/2/25.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

enum MessageBodyType {
    //样式为文字
    case MessageBodyTypeText
    //样式为图片
    case MessageBodyTypeImage
}

class MDSChatModel: NSObject {
    
    //文字内容
    var content:String?;
    
    //日期
    var dataStr:String?;
    
    //图片
    var imgUrl:String?;
    
    var type:MessageBodyType?;
    
    var isMine:Bool?;
}
