//
//  MDNavController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = true;
        //侧滑返回
        self.interactivePopGestureRecognizer?.isEnabled = true;
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            
        }
    }
    
    
    /**
     *  重写这个方法,能拦截所有的push操作
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
            if viewController is MDSBaseController {
                let vc:MDSBaseController = viewController as! MDSBaseController
                vc.addBackNav(image: kImage("backNav"))
            }else {
                //统一返回按钮
                viewController.addBackNav(image: kImage("backNav"), sel: #selector(backBtnClick))
            }
        }
        super.pushViewController(viewController, animated: animated);
    }

    @objc func backBtnClick(){
        self.navigationController?.popViewController(animated: true)
    }
}
