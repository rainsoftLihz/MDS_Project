//
//  MDSHomeController.swift
//  MDS
//
//  Created by rainsoft on 2019/2/24.
//  Copyright © 2019年 jzt. All rights reserved.
//

import UIKit
import HandyJSON
class MDSHomeController: MDSBaseController,UICollectionViewDelegate,UICollectionViewDataSource {
    var page:Int = 1
    
    var dataArr:[MDSHomeModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(title: "首页")
        self.view.addSubview(self.collectionView);
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.myNavView.snp_bottom)
            make.left.right.bottom.equalToSuperview()
        }
        self.collectionView.addMJHeader {
            self.page = 1
            self.loadData();
        }
        
        self.collectionView.addMJFooter {
           self.loadData();
        }
        
        self.collectionView.mj_header?.beginRefreshing()
    }
    
    @objc func loadData()  {
        let params:[String:Any] = ["classId":"",
                                   "gradeId":"",
                                   "homeworkName":"",
                                   "schoolName":"",
                                   "schoolId":"",
                                   "subjectId":"",
                                   "pageNum":self.page,
                                   "pageSize":10];
        
        HomeProvider.requsetData(MDSHomeAPI.findHomeworkList(params: params),completion: { (response) -> (Void) in

                self.collectionView.mj_header?.endRefreshing()
                self.collectionView.mj_footer?.endRefreshing()
            
                if (response.isSucces){
                    if let tempDataArr = JSONDeserializer<MDSHomeModel>.deserializeModelArrayFrom(array: response.data as? [Any]) {
                        if self.page == 1 {
                            self.dataArr = tempDataArr as? [MDSHomeModel]
                        }else {
                            self.dataArr?.append(contentsOf: (tempDataArr as? [MDSHomeModel])!)
                        }
                        
                        let count:NSInteger = self.dataArr!.count
                        if self.dataArr!.count >= response.total {
                            self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                            self.collectionView.mj_footer?.isHidden = (count < 8)
                        }else{
                            self.page += 1
                        }
                        
                        if count == 0 {
                            self.collectionView.mj_footer?.isHidden = true
                        }
                        
                        self.collectionView.reloadData()
                    }
                }else{
                    if response.rtnCode == 900 {
                        //跳转主页
                        let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
                        appDelegate.gotoLogin()
                    }
            }
        });
    }

    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init();
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 160);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .vertical;
        
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout);
        collection.delegate = self;
        collection.dataSource = self;
        collection.showsVerticalScrollIndicator = false;
        collection.showsHorizontalScrollIndicator = false;
        collection.backgroundColor = UIColorFromRGB(0xf6f6f6);
        collection.register(MDSHomeViewCell.classForCoder(), forCellWithReuseIdentifier: MDSHomeViewCell.identer());
        return collection;
    }();
    
    
    
    //MARK datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0;
    }
    
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "MDSHomeViewCell";
        let cell:MDSHomeViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MDSHomeViewCell
        cell.model = self.dataArr![indexPath.row]
        return cell;
    }
   
 
    //MARK  delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
    }
}
