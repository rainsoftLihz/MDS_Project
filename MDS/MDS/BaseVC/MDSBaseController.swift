//
//  MDSBaseController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSBaseController: UIViewController {
    
    //重写init 添加返回按钮
    init() {
        super.init(nibName: nil, bundle: nil);
        
        //背景色
        self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        //统一返回按钮
        let backBtn:UIButton = UIButton(type: .custom);
        backBtn.frame = CGRect(x: 0, y: 0, width: 21, height: 21);
        backBtn.setImage(UIImage(named: "backNav"), for: .normal);
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn);

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @objc func backBtnClick() {
        self.navigationController?.popViewController(animated: false);
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
