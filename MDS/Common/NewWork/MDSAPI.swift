//
//  MDSAPI.swift
//  MDS
//
//  Created by rainsoft on 2019/2/26.
//  Copyright © 2019年 jzt. All rights reserved.
//

import Foundation
import Moya

enum MDSAPI {
    case findHomeworkList(params:[String : Any])
    case login(params:[String : Any])
}

extension MDSAPI:TargetType{

    var baseURL: URL {
        return URL.init(string: MDS_BaseURL)!
    }
    
    var path: String {
        switch self {
            case .findHomeworkList:
                return "/homework-api/homework/process/findHomeworkList";
            case .login:
                return "/marking-api/login/login";
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .findHomeworkList:
                return .post
            case .login:
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
        case .login(params: let parmas):
            return .requestParameters(parameters: parmas, encoding: JSONEncoding.default);
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    var needShowHud: Bool {
        return true
    }

}
