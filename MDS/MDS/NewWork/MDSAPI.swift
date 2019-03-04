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
    case login(userName:String,passwd:String)
    case weather(location:String,output:String)
    case defaultRequest
}

extension MDSAPI:TargetType{
    var baseURL: URL {
        switch self {
        case .defaultRequest:
            return URL.init(string:"http://api.map.baidu.com")!
        default:
            return URL.init(string:("http://api.map.baidu.com"))!
        }
    }
    
    var path: String {
        switch self {
        case .weather:
            return "/telematics/v3/weather";
        default:
            return "register";
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .defaultRequest:
            return .get
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters = [String:Any]()
        switch self {
        case .defaultRequest:
            return .requestPlain;
        case .weather(let location, let output):
            parmeters["location"] = location;
            parmeters["output"] = output;
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default);
        default:
            return .requestPlain;
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
}
