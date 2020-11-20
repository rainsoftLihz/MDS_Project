//
//  MDSTestGestureController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
class MDSTestGestureController:
    MDSBaseController,
    UIScrollViewDelegate,
    UITableViewDelegate,
UITableViewDataSource,ScrollActionDelegate {
    
    
    
    let footerVC = MDSFooterController()
    
    lazy var tableView:UITableView = {
        let temp:UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.register(MDSSelectCell.self, forCellReuseIdentifier: "MDSSelectCell")
        temp.tableFooterView = self.footerView
        temp.bounces = true
        temp.separatorStyle = .none
        temp.rowHeight = 44
        temp.delegate = self
        temp.dataSource = self
        return temp
    }()
    
    lazy var footerView:UIView = {
        let temp:UIView = UIView.createView(backgroundColor: .white)
        temp.myFrame(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.myNavView.maxY)
        temp.addSubview(self.footerVC.view)
        self.footerVC.view.frame = temp.bounds
        self.addChild(self.footerVC)
        self.footerVC.didMove(toParent: self)
        self.footerVC.canScroll = false
        self.footerVC.delegate = self
        self.footerVC.addSubview()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "卡片")
        self.view.addSubview(self.tableView)
        self.tableView.myFrame(0, self.myNavView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.myNavView.maxY)
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MDSSelectCell = MDSSelectCell.init(style: .default, reuseIdentifier: "MDSSelectCell")
        cell.titleLab.text = String.init(format: "第%ld", indexPath.row)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 6*44 {
            scrollView.setContentOffset(CGPoint.init(x: 0, y: 6*44), animated: true)
            self.tableView.isScrollEnabled = false
            self.footerVC.canScroll = true
        }else {
            self.tableView.isScrollEnabled = true
            self.footerVC.canScroll = false
        }
        
        print("scrollView.contentOffset.y=\(offsetY)")
    }
    
    func scrollViewDidScrollTo(offsetY: CGFloat) {
        print("footerscrollView.contentOffset.y=\(offsetY)")
        if offsetY > 0{
            self.tableView.isScrollEnabled = false
            self.footerVC.canScroll = true
        }else{
            self.tableView.isScrollEnabled = true
            self.footerVC.canScroll = false
        }
    }
}
