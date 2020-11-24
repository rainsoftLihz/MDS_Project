//
//  MDSHomeAPI.swift
//  MDS
//
//  Created by rainsoft on 2020/10/26.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import Moya

//网络请求的核心初始化方法  创建网络请求对象
let HomeProvider = MoyaProvider<MDSHomeAPI>(endpointClosure:myEndpointClosure,requestClosure:myRequestClosure,plugins:[],trackInflights: false);

enum MDSHomeAPI {
    case findHomeworkList(params:[String : Any])
    case uploadImgString(params:[String : Any])
}

extension MDSHomeAPI:TargetType,MoyaAddable{

    var needShowHud: Bool {
        return false
    }
    
    var baseURL: URL {
        switch self {
        case .findHomeworkList:
            return URL.init(string: MDS_BaseURL)!
        case .uploadImgString:
            return URL.init(string: "http://10.10.48.110:8000")!
                
                //URL.init(string: "http://123.56.54.15:80")!
        }
    }
    
    var path: String {
        switch self {
            case .findHomeworkList:
                return "/homework-api/homework/process/findHomeworkList"
        case .uploadImgString:
            return "/kly-pro-smartapi/photo_marking_pro"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .findHomeworkList:
                return .post
        case .uploadImgString:
            return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .findHomeworkList(params: let parmeters):
            return .requestParameters(parameters: parmeters, encoding: JSONEncoding.default);
        case .uploadImgString(params: let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default);
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }

}
