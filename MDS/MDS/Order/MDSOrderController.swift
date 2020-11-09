//
//  MDSOrderController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit

class MDSOrderController: MDSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitle(title: "订单")
        
        let urlArray = ["http://i.imgur.com/7Ze2PdG.png","http://i.imgur.com/cAfBaMR.png","http://i.imgur.com/AimYvXb.png"]
        
        let cycleView:MDSCyclicScrollView = MDSCyclicScrollView.init(frame: CGRect.init(x: 0, y: self.myNavView.maxY+10, width: SCREEN_WIDTH, height: 100))
        self.view.addSubview(cycleView)
        cycleView.dataArr = urlArray
         
    }

}
