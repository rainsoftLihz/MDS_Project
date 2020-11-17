//
//  MDSLearnAPI.swift
//  MDS
//
//  Created by rainsoft on 2020/11/11.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import Moya

//网络请求的核心初始化方法  创建网络请求对象
let LearnProvider = MoyaProvider<MDSLearnAPI>(endpointClosure:myEndpointClosure,requestClosure:myRequestClosure,plugins:[],trackInflights: false);

enum MDSLearnAPI {
    case getLsLeEntryCarouselByLsId(params:[String : Any])
}

extension MDSLearnAPI:TargetType,MoyaAddable{
    
    var needShowHud:Bool{
        return true
    }
    
    
    var baseURL: URL {
        return URL.init(string: "https://www.memoplanet.com")!
    }
    
    var path: String {
        switch self {
            case .getLsLeEntryCarouselByLsId:
                return "/sealionv2/wxx/learningentry/getLsLeEntryCarouselByLsId";
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getLsLeEntryCarouselByLsId:
                return .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .getLsLeEntryCarouselByLsId(params: let parmas):
            return .requestParameters(parameters: parmas, encoding: JSONEncoding.default);
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    

}
