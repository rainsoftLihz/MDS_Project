//
//  MDSHomeController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
class MDSHomeController: MDSBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.creatBtn();
        self.requstData();
    
    }
    
    func requstData(){
       
        MDSMovieApiProvider.request(MDSMovieApi.movie(apikey: "0b2bdeda43b5688921839c8ecb20399b", city: "北京")) { (result) in
            switch result {
            case .success(let response):
                do {
                   
                    /// 解析数据
                    let data = try?response.mapJSON();
                    let json  = JSON(data!);
                    if let mappedObj = JSONDeserializer<MDSMovieModelList>.deserializeFrom(json: json.description){
                        print(mappedObj);
                        let dattArr:[MDSMovieModel] = mappedObj.subjects!;
                        for em in dattArr  {
                            NSLog("===%@", em.title!);
                        }
                    }
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func creatBtn() {
        let btn:UIButton = UIButton(type: UIButton.ButtonType.custom);
        btn.frame = CGRect(x:100,y:100,width:100,height:40);
        btn.setTitle("点我跳转",for: .normal);
        btn.backgroundColor = UIColor.red;
        btn.setTitleColor(UIColor.white, for: .normal);
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0);
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    
    @objc func btnClick(btn:UIButton) {
        let vc:MDSAAAController = MDSAAAController();
        self.navigationController?.pushViewController(vc, animated: true);
    }

    
}
