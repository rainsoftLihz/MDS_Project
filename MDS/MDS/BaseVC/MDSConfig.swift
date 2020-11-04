//
//  MDSConfig.swift
//  MDS
//
//  Created by rainsoft on 2020/10/21.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation

// 定义基础域名
let MDS_BaseURL = "http://101.200.91.162"

struct RuntimeKey {
    static let ClickBlockKey = UnsafeRawPointer.init(bitPattern: "ClickBlockKey".hashValue)
}
