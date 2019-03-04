//
//  File.swift
//  MDS
//
//  Created by rainsoft on 2019/3/4.
//  Copyright © 2019年 jzt. All rights reserved.
//

import Foundation
import Moya

let MDSMovieApiProvider = MoyaProvider<MDSMovieApi>()

enum MDSMovieApi {
    case movie(apikey:String,city:String)
}

extension MDSMovieApi:TargetType{
    var baseURL: URL {
        return NSURL.fileURL(withPath: "http://api.douban.com") ;
    }
    
    var path: String {
        return "/v2/movie/in_theaters"
    }
    
    var method: Moya.Method {
        return .get;
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        var parmeters = [String:Any]()
        switch self {
        case .movie(let apikey, let city):
            parmeters["apikey"] = apikey;
            parmeters["city"] = city;
            parmeters["count"] = 100;
            
            return .requestParameters(parameters: parmeters, encoding: URLEncoding.default);
        }
    }
    
    var headers: [String : String]? {
         return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    
}
