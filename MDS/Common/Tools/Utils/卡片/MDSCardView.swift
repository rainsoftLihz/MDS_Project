//
//  MDSCardView.swift
//  MDS
//
//  Created by rainsoft on 2020/11/10.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

@objc protocol MDSCardViewDataSource:NSObjectProtocol{
    //自定义cell
    func configCollectionCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
}

class MDSCardView: UIView,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    let registerID = "MDSCardViewRegisterID"
    //是否支持缩放功能
    var isCanScale:Bool = false {
        didSet {
            self.layout.canScaleWithScroll = isCanScale
        }
    }
    
    //代理---实现自定义cell,不限制cell类型
    weak open var dataSource: MDSCardViewDataSource?
    
    //滑动的起始位置
    var startX:CGFloat = 0
    var endX:CGFloat = 0
    
    //点击事件回掉
    var didSelectClosure:((Int)->())?
    //滚动事件回掉
    var didScrollEndDraggingClosure:((Int)->())?
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
    
    //Layout
    var layout:MDSCustomLayout = MDSCustomLayout.init()
    
    private lazy var collectionView:UICollectionView = {
        //不能设置page
        let collectionView:UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    //MARK: --- init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    convenience init(frame: CGRect,didSelectClosure:@escaping ((Int)->())) {
        self.init(frame: frame)
        self.didSelectClosure = didSelectClosure
    }
    
    convenience init(frame: CGRect,canScale:Bool,didSelectClosure:@escaping ((Int)->())) {
        self.init(frame: frame)
        self.isCanScale = canScale
        self.didSelectClosure = didSelectClosure
    }
    
    
    //MARK: ---- collectionViewDatasource -----
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (self.dataSource?.configCollectionCell(collectionView, indexPath: indexPath))!
    }
    
    //MARK: ---- collectionViewDelegate -----
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.startX = scrollView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // 设置targetContentOffset之后就不会有惯性减速了 必须设置
        targetContentOffset.pointee = scrollView.contentOffset
        self.endX = scrollView.contentOffset.x
        DispatchQueue.main.async {
            self.scrollToIndex()
        }
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
        
        var indexPath:IndexPath = self.collectionView.indexPath(for: centerCell!)!
        
        // 滑动距离太短,就认为是未滑动,还回到中间位置  visibleCells 为3
        if (self.collectionView.visibleCells.count==3) {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            return;
        }
        
        
        // 右滑
        if (self.endX > self.startX) {
            indexPath = self.collectionView.indexPath(for: rightCell!)!
        }
        // 左滑
        if (self.endX < self.startX) {
            indexPath = self.collectionView.indexPath(for: leftCell!)!
        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if (self.didScrollEndDraggingClosure != nil) {
            self.didScrollEndDraggingClosure!(indexPath.item)
        }
        
    }
    
    //MARK: ---- scrollViewDelegate end -----
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class MDSCardCell: UICollectionViewCell {
    
    var imgV:UIImageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(self.imgV)
        self.imgV.frame = self.bounds
        
        print("=========init========")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
