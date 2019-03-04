//
//  MDSMovieModel.swift
//  MDS
//
//  Created by rainsoft on 2019/3/4.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
import HandyJSON
class MDSMovieModelList: HandyJSON {
    var subjects:[MDSMovieModel]?;
    required init() {};
}

class MDSMovieModel: HandyJSON {
    //电影名
    var title:String?;
    //剧照
    var images:Dictionary<String,String>?;
    
    required init() {};
}
