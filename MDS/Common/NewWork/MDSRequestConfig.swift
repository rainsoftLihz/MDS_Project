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
private var requestTimeOut:Double = 45;
//成功数据回调
typealias CompletBlock = ((MDSResponse) ->(Void));

//MARK: ---设置请求头,公共参数
public let myEndpointClosure = {(target:TargetType) -> Endpoint in
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
    return endpoint.adding(newHTTPHeaderFields: ["Authorization":"32e5f39f-7efe-453c-ab3d-2e5ce2095cb0"]);
}

//设置超时时长等
public let myRequestClosure = {(endpoint:Endpoint,done:MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest();
        //设置超时时长
        request.timeoutInterval = requestTimeOut;
        done(.success(request));
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}


public let myNetworkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
        case .began:
            print("开始请求网络")
            
        case .ended:
            print("结束")
    }
}

//MARK: --- TargetType扩展字段
protocol MoyaAddable {
    var needShowHud:Bool{get}
    
}

//MARK: --- 统一请求数据处理
extension MoyaProvider{
    func requsetData<R: TargetType & MoyaAddable >(_ target: R, completion: @escaping CompletBlock) -> Cancellable{
        
        if target.needShowHud {
            UIView.dismissHud()
            UIView.showHud()
        }

        return self.request(target as! Target) { (result) in
            UIView.dismissHud()
            switch result {
                case let .success(response):
                    do {
                        let dic = try response.mapJSON() as! [String : Any]
                        let resultData:MDSResponse = MDSResponse.deserialize(from: dic)!
                        completion(resultData)
                    } catch {
                        let resultData:MDSResponse = MDSResponse.init()
                        resultData.status = response.statusCode
                        resultData.msg = "网络请求异常"
                        completion(resultData)
                        if target.needShowHud {
                            UIView.showTipsText("网络请求异常")
                        }
                    }
                case let .failure(error):
                    let resultData:MDSResponse = MDSResponse.init()
                    resultData.status = error.errorCode
                    resultData.msg = "网络连接失败"
                    completion(resultData)
                    
                    if target.needShowHud {
                        UIView.showTipsText("网络连接失败")
                    }
                }
        }
    }
}

