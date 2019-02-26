//
//  MDSBBBViewController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSBBBController: MDSBaseController {

 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "BBB";
        
        let img:UIImageView = UIImageView(image: UIImage(named: "wtfk"));
        img.isUserInteractionEnabled = true;
        self.view.addSubview(img);
        img.snp.makeConstraints { (make) in
            make.left.equalTo(100);
            make.top.equalTo(130);
        }
        
        //点击手势
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotoCCC(tap:)));
        img.addGestureRecognizer(tap);
        
        
        let btn:QMUIButton = QMUIButton(type: .custom);
        btn.setTitle("跳转返回", for: .normal);
        btn.setImage(UIImage(named: "wtfk"), for: .normal);
        //图片位置
        btn.imagePosition = QMUIButtonImagePosition.top;
        //图文间距
        btn.spacingBetweenImageAndTitle = 15;
        
        self.view.addSubview(btn);
        
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.left);
            make.top.equalTo(img.snp.bottom).offset(20);
        }
    }
    

    @objc func gotoCCC(tap:UITapGestureRecognizer){
        self.navigationController?.pushViewController(MDSCCCController(), animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
