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
}

extension MDSHomeAPI:TargetType,MoyaAddable{

    var needShowHud: Bool {
        return true
    }
    
    var baseURL: URL {
        return URL.init(string: MDS_BaseURL)!
    }
    
    var path: String {
        switch self {
            case .findHomeworkList:
                return "/homework-api/homework/process/findHomeworkList";
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .findHomeworkList:
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
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }

}
