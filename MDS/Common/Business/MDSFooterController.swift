//
//  MDSFooterController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

protocol ScrollActionDelegate:NSObjectProtocol {
    func scrollViewDidScrollTo(offsetY:CGFloat) -> Void
    
}

class MDSFooterController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
UIScrollViewDelegate {
    
    weak var delegate:ScrollActionDelegate?
    
    var canScroll:Bool = false {
        didSet{
            self.tableView.isScrollEnabled = canScroll
        }
    }
    
    lazy var tableView:UITableView = {
        let temp:UITableView = UITableView.init(frame: CGRect.zero, style: .plain)
        temp.backgroundColor = UIColor.groupTableViewBackground
        temp.register(MDSSelectCell.self, forCellReuseIdentifier: "MDSSelectCell")
        temp.tableFooterView = UIView.init(frame: CGRect.zero)
        temp.bounces = true
        temp.separatorStyle = .none
        temp.rowHeight = 44
        temp.delegate = self
        temp.dataSource = self
        temp.isScrollEnabled = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColorFromRGBAlpha(0x000000,0.5)
        
    }
    
    func addSubview() {
        let headerV = UIView.createView(backgroundColor: .black)
        headerV.myFrame(0, 0, SCREEN_WIDTH, 44)
        self.view.addSubview(headerV)
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.tableView)
        self.tableView.myFrame(0, headerV.maxY, SCREEN_WIDTH, self.view.height-headerV.maxY)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MDSSelectCell = MDSSelectCell.init(style: .default, reuseIdentifier: "MDSSelectCell")
        cell.titleLab.text = String.init(format: "footer第%ld", indexPath.row)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(String.init(format: "footer第%ld", indexPath.row))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.delegate != nil) {
            self.delegate?.scrollViewDidScrollTo(offsetY: scrollView.contentOffset.y)
        }
    }
}
