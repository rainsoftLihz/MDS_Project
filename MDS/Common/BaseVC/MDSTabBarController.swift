//
//  MDSTabBarController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAllChildVc()
        #if MDS
        self.tabBar.barTintColor = UIColor.red
        #else
        self.tabBar.barTintColor = UIColor.yellow
        #endif
    }
    
    //添加子控制器
    func addAllChildVc()  {
        for index in 0..<childVCArr.count{
            self.addChildViewController(childVC: childVCArr[index], title: titleArr[index], normalImg: normalImageArray[index], selectedImg: selectedImageArray[index]);
        }
    }
    
    //创建子控制器
    func addChildViewController(childVC:MDSBaseController,title:String,
                              normalImg:String,selectedImg:String)  {
        //同时设置导航栏和tabbar
        //childVC.title = title;
        
        //只设置tabbaritem上的title
        //childVC.tabBarItem.title = title;
        
        //只设置页面导航栏的title
        //childVC.navigationItem.title = title;
        childVC.tabBarItem.image = UIImage(named: normalImg);
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImg)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal);
        
        //主界面隐藏返回按钮
        //childVC.navigationItem.hidesBackButton = true;
        //childVC.navigationItem.leftBarButtonItem = nil;
        
        
        //没有文字的时候 图片剧中
        childVC.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0);
        let nav = MDSNavController.init(rootViewController: childVC);
        self.addChild(nav);
    }
    
    //控制器
    var childVCArr = [MDSHomeController(),MDSOrderController(),MDSBussinessController(),MDSMinewController()];
    
   
    //标题
    var titleArr = ["主页","购物车","业务圈","我的"];
    
    //选中时候图片
    var selectedImageArray = ["sy50","gwc50","ywc50","wd50"];
    
    //默认图片
    var normalImageArray = ["sy00","gwc00","ywc00","wd00"];

}
