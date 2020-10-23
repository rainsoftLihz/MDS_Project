//
//  ScrollView+MJ.swift
//  MDS
//
//  Created by rainsoft on 2020/10/23.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import UIKit
extension UIScrollView{
    
    typealias RefreashHeader = (() -> (Void))
    typealias RefreashFooter = (() -> (Void))
    func addMJHeader(refreash:@escaping RefreashHeader) {
        let mjHeader = MJRefreshNormalHeader.init {
            refreash();
        }
        self.mj_header = mjHeader
    }
    
    func addMJFooter(refreash:@escaping RefreashFooter) {
        let mjFooter = MJRefreshAutoNormalFooter.init {
            refreash();
        }
        //修改文字
        mjFooter.setTitle("上拉加载", for: .idle)//普通闲置的状态
        mjFooter.setTitle("正在加载中", for: .refreshing)//正在刷新的状态
        mjFooter.setTitle("\n我是有底线的", for: .noMoreData)//数据加载完毕的状态
        self.mj_footer = mjFooter
    }
    
}

