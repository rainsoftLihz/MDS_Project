//
//  MDSCardController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSCardController:
MDSBaseController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    //中间卡片距离屏幕左右的间距
    var edgesSpace:CGFloat = 40
    
    //MARK:--- 子类重写 自定义cell
    open var cellClass:MDSCardBaseCell.Type {
        return MDSCardBaseCell.self
    }
    
    //点击时间回掉
    var didSelectClosure:((Int)->())?

       //数据源
       var dataArr:[Any]? {
           didSet{
               if dataArr == nil {
                   return
               }
            self.collectionView.reloadData()
           }
       }

    
    private lazy var collectionView:UICollectionView = {
        //collection frame
        let rect = CGRect(x: 10, y: 64, width:SCREEN_WIDTH , height: SCREEN_HEIGHT-NAV_BAR_HEIGHT-10)
        //自定义Layout
        let layout:MDSCustomLayout = MDSCustomLayout()
        layout.itemSize = CGSize(width: SCREEN_WIDTH-2*edgesSpace, height: rect.size.height)
        //不能设置page
        let collectionView:UICollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(self.cellClass, forCellWithReuseIdentifier: "MDSCardBaseCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        self.addTitle(title: "卡片")
        self.view.addSubview(self.collectionView)
    }
    
    
    //MARK:---delegetes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataArr == nil {
            return 0
        }
        return self.dataArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cardCell:MDSCardBaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MDSCardBaseCell", for: indexPath) as! MDSCardBaseCell
        
        let data = self.dataArr![indexPath.item]
        
        self.configureCollectionCell(cardCell, data: data)
        
        return cardCell
    }
    
    
    
    //子类重写此方法
    func configureCollectionCell(_ cell:MDSCardBaseCell,data:Any) {
        
    }
}
