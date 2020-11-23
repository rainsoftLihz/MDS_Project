//
//  MDSAIModel.swift
//  MDS
//
//  Created by rainsoft on 2020/11/23.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import HandyJSON
class MDSAIModel: HandyJSON {
    
    var index:Int = -1
    
    var box:[Int]?
    
    var info:MDSAIInfoModel?

    required init() {}
}


class MDSAIInfoModel: HandyJSON {
    
    var label:Int = 0
    //答案
    var db:String?
    //学生作答
    var answer:String?
    
    //有字符串就显示答案 么有就不展示
    var mark:String?
    
    required init() {}
}
