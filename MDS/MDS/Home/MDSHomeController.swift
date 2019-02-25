//
//  MDSHomeController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSHomeController: MDSBaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.creatBtn();
    
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
