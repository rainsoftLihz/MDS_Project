//
//  MDSAAAController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSAAAController: MDSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "AAA";
        
        self.view.addSubview(self.btn);
    }
    
    private let btn:UIButton =  {
        let button = UIButton(type: UIButton.ButtonType.custom);
        button.setTitle("跳转到BBB VC", for: .normal);
        button.backgroundColor = UIColor.red;
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40);
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
        button.addTarget(self, action: #selector(gotoBBB), for: .touchUpInside)
        return button
    }();
    

    @objc func gotoBBB()  {
        self.navigationController?.pushViewController(MDSBBBController(), animated: true);
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
