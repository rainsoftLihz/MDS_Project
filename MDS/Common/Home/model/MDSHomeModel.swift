//
//  MDSHomeModel.swift
//  MDS
//
//  Created by rainsoft on 2020/10/21.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import HandyJSON
/*
 /// 作业名称
 @property (nonatomic, copy) NSString *homeworkName;

 /// 报告是否推送
 @property (nonatomic, assign) BOOL hasPush;

 /// 客观题数
 @property (nonatomic, strong) NSNumber *objectiveQueTotal;

 /// 班级
 @property (nonatomic, copy) NSString *className;

 /// 客观题正确率
 @property (nonatomic, copy) NSString *objQueRand;

 /// 主观题数
 @property (nonatomic, strong) NSNumber *subjectiveQueTotal;

 /// 批改进度 不带百分号
 @property (nonatomic, assign) NSNumber *markProgress;

 /// 创建时间
 @property (nonatomic, copy) NSString *createTime;

 @property (nonatomic, copy) NSString *scanTime;
 //UI需要展示的时间
 @property (nonatomic,strong)NSString* dataStr;
 /// 作业id
 @property (nonatomic, copy) NSString *homeworkProcessId;

 /// 作业是否交齐
 @property (nonatomic, assign) BOOL isAll;

 /// PaperId
 @property (nonatomic, copy) NSString *tkPaperId;

 /// 主观题正确率
 @property (nonatomic, copy) NSString *subjQueRand;

 /// 比例
 @property (nonatomic, copy) NSString *stuNumDetail;

 /// 批改进度 带百分号
 @property (nonatomic, copy) NSString *markProgressStr;

 //是否需要收起时间
 @property (nonatomic, assign) BOOL showTimeFlag;

 //(0, "打印痕迹"),(1, "已通知"),(2, "已打印")
 @property (nonatomic, assign) NSInteger printStatus;
 @property (nonatomic, copy) NSString *printStr;
 */

class MDSHomeModel: HandyJSON {
    // 作业名称
    var homeworkName:String?
    // 班级
    var className:String?
    //时间
    var scanTime:String?
    //已交/总
    var stuNumDetail:String?
    //批阅进度
    var markProgress:Int = 0
    var markProgressStr:String?
    
    
    //(0, "打印痕迹"),(1, "已通知"),(2, "已打印")
    var printStatus:Int = 0
    
    var printStr:String?{
        if self.printStatus == 1 {
            return "已通知"
        }
        if self.printStatus == 2 {
            return "已打印"
        }
        return "打印痕迹"
    }
    
    
    //是否需要收起时间
    var showTimeFlag:Bool?
    
    
    required init() {
        
    }
}

