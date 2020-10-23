//
//  MDSResponse.swift
//  MDS
//
//  Created by rainsoft on 2020/10/21.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import HandyJSON
class MDSResponse: HandyJSON {
    //分页页数
    var totalPage:Int = 0
    //总条数
    var total:Int = 0
    //状态码
    var rtnCode:Int = 0
    //提示信息
    var rtnMsg:String?
    // 数据
    var data:Any?

    var isSucces:Bool{
        get{
            return self.rtnCode == 200
        }
    }
    
    required init() {
    }
}
