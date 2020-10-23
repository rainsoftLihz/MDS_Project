//
//  MDSNetWork.swift
//  MDS
//
//  Created by rainsoft on 2019/2/26.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import SwiftyJSON
import HandyJSON
//超时时长
private var requestTimeOut:Double = 30;
//成功数据回调
typealias CompletBlock = ((MDSResponse) ->(Void));

//设置请求头
private let myEndpointClosure = {(target:TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString+target.path;
    var task = target.task;
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    //设置cookie
    if let myCookie:String = UserDefaults.standard.string(forKey: "mUserDefaultsCookie"){
        if target.path.contains("/login") {
            return endpoint
        }
        return endpoint.adding(newHTTPHeaderFields: ["cookie":myCookie])
    }
    return endpoint;
}

//设置超时时长等
private let requestClosure = {(endpoint:Endpoint,done:MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest();
        //设置超时时长
        request.timeoutInterval = requestTimeOut;
        
        done(.success(request));
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

///NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
        case .began:
            print("开始请求网络")
            
        case .ended:
            print("结束")
    }
}

//网络请求的核心初始化方法  创建网络请求对象
let Provider = MoyaProvider<MDSAPI>(endpointClosure:myEndpointClosure,requestClosure:requestClosure,plugins:[],trackInflights: false);

func NetWorkRequest(_ target: MDSAPI, completion: @escaping CompletBlock) {
    
    if target.needShowHud {
        UIView.showHud()
    }
    
    Provider.request(target) { (result) in
        
        //隐藏hud
        UIView.dismissHud()
        
        switch result {
            case let .success(response):
                do {
                    let dic = try response.mapJSON() as! [String : Any]
                    let resultData:MDSResponse = JSONDeserializer<MDSResponse>.deserializeFrom(dict: dic)!
                    completion(resultData)
                } catch {
                    
                }
            case let .failure(error):
                let resultData:MDSResponse = MDSResponse.init()
                resultData.rtnCode = error.errorCode
                resultData.rtnMsg = "网络连接失败"
                completion(resultData)
            }
    }
}

