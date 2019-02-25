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

        // Do any additional setup after loading the view.
        
        navigationBar.isTranslucent = true;
        
        //导航栏颜色
        navigationBar.barTintColor = UIColor.white;
        //navigationBar.setBackgroundImage(UIImage(named: "navbg"), forBarMetrics: UIBarMetrics.Default)
        
        //设置导航栏标题的大小颜色等
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20),
             NSAttributedString.Key.foregroundColor:UIColor.red];
        
        //侧滑返回
        self.interactivePopGestureRecognizer?.isEnabled = true;
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            
        }
    }
    
    
    /**
     *  重写这个方法,能拦截所有的push操作
     *
     */
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated);
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
