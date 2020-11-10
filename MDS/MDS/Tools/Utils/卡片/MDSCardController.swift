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
    
    let registerID = "MDSCardBaseCell"
    //中间卡片距离屏幕左右的间距
    var edgesSpace:CGFloat = 40
    
    //滑动的起始位置
    var startX:CGFloat = 0
    var endX:CGFloat = 0
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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    
    private lazy var collectionView:UICollectionView = {
        //collection frame
        let rect = CGRect(x: 0, y: NAV_BAR_HEIGHT+60, width:SCREEN_WIDTH , height: SCREEN_HEIGHT-NAV_BAR_HEIGHT-60-60)
        //自定义Layout
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: rect.size.width*0.85, height: rect.size.height)
        //不能设置page
        let collectionView:UICollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(self.cellClass, forCellWithReuseIdentifier: self.registerID)
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

        let cardCell:MDSCardBaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.registerID, for: indexPath) as! MDSCardBaseCell
        
        let data = self.dataArr![indexPath.item]
        
        self.configureCollectionCell(cardCell, data: data,indexPath: indexPath)
        
        return cardCell
    }
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.dataArr == nil {
            return
        }
        
        //        for cell in self.collectionView.visibleCells {
        //            let centerPoint = self.view.convert(cell.center, from: scrollView)
        //            //缩放
        //            let d = abs(centerPoint.x - SCREEN_WIDTH*0.5)/cell.contentView.bounds.size.width
        //            // 中间的为1,旁边2个为0.9
        //            let scale:CGFloat = 1-0.1*d ;
        //            cell.layer.transform = CATransform3DMakeScale(scale, scale, 1);
        //        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 设置targetContentOffset之后就不会有惯性减速了 必须设置
        targetContentOffset.pointee = scrollView.contentOffset
        self.endX = scrollView.contentOffset.x
        self.scrollToIndex()
    }
    
    func scrollToIndex() {
        var centerCell = self.collectionView.visibleCells.first
        var rightCell = self.collectionView.visibleCells.first
        var leftCell = self.collectionView.visibleCells.first
        for cell in self.collectionView.visibleCells {
            if cell.frame.origin.x > rightCell!.frame.origin.x {
                rightCell = cell
            }else if cell.frame.origin.x < leftCell!.frame.origin.x {
                leftCell = cell
            }
        }
        
        for cell in self.collectionView.visibleCells {
            if (cell == leftCell || cell==rightCell) {
                continue;
            }
            centerCell = cell;
        }
        
        // 滑动距离太短,就认为是未滑动,还回到中间位置  visibleCells 为3
        if (self.collectionView.visibleCells.count==3) {
            self.collectionView.scrollToItem(at: self.collectionView.indexPath(for: centerCell!)!, at: .centeredHorizontally, animated: true)
            return;
        }
        
        // 右滑
        if (self.endX > self.startX) {
            self.collectionView.scrollToItem(at: self.collectionView.indexPath(for: rightCell!)!, at: .centeredHorizontally, animated: true)
        }
        // 左滑
        if (self.endX < self.startX) {
            self.collectionView.scrollToItem(at: self.collectionView.indexPath(for: leftCell!)!, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
    //子类重写此方法
    func configureCollectionCell(_ cell:MDSCardBaseCell,data:Any,indexPath:IndexPath) {
        
    }
}
