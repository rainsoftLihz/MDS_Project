//
//  MDSCyclicScrollView.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit



class MDSCyclicScrollView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let kCYScrollCellId = "kCYScrollCellId"
    
    var didSelectClosure:((Int)->())?
    
    var autoRun:Bool = true
    
    //定时器
    private var timer:Timer?
    //数据源
    var dataArr:[Any]? {
        didSet{
            if dataArr == nil {
                return
            }
            self.refresh()
            self.setPageControl()
        }
    }
    //collectionView
    private lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(MDSCyclicCell.self, forCellWithReuseIdentifier: kCYScrollCellId)
        return collectionView
    }()
    
    //pageControl
    public lazy var pageControl:UIPageControl = {
        let pageControl:UIPageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        //设置pageControl未选中的点的颜色
        pageControl.pageIndicatorTintColor = UIColor.gray
        //设置pageControl选中的点的颜色
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)
        self.collectionView.myFrame(10, 10, self.width-20, self.height-20)
    }
    
    convenience init(frame: CGRect,dataArr: [Any],didSelectClosure:@escaping ((Int)->())) {
        self.init(frame: frame)
        self.dataArr = dataArr
        self.didSelectClosure = didSelectClosure
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:---delegetes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataArr == nil {
            return 0
        }
        
        //左右各留一个cell用于轮播
        let number = self.dataArr!.count>1 ? self.dataArr!.count+2 : self.dataArr!.count
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bannerCell:MDSCyclicCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCYScrollCellId, for: indexPath) as! MDSCyclicCell
        
        let index = self.transferIndex(indexPath.row)
        let data = self.dataArr![index]
        if data is String {
            if let urlString = data as? String{
                let url:URL = URL(string: urlString)!
                bannerCell.imageView.kf.setImage(with: url)
            }
        }else if data is UIImage {
            if let image = data as? UIImage{
                bannerCell.imageView.image = image
            }
        }
        
        return bannerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: self.collectionView.width, height: self.collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = self.transferIndex(indexPath.row)
        if (self.didSelectClosure != nil) {
            self.didSelectClosure!(index)
        }
    }
    
    
    //MARK:--- scroll
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.resetTimer()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.dataArr == nil {
            return
        }
        
        let index:Float = Float(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width)
        
        //切换item
        if index < 0.25 {
            self.collectionView.scrollToItem(at: IndexPath(item: self.dataArr!.count, section: 0), at: [.top,.left], animated: false)
        }else if index >= Float(self.dataArr!.count+1) {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
        }
        
        let page = self.transferIndex(Int(index))
        self.pageControl.currentPage = page
        
    }
    
    //MARK:- page control setting
    public func setPageControl() {
       
       if self.dataArr == nil || self.dataArr!.count <= 1 {
           self.pageControl.isHidden = true
           return
       }
       self.pageControl.isHidden = false
       self.pageControl.numberOfPages = self.dataArr!.count
       let pageControlWidth:Double = Double(self.dataArr!.count) * 15
       let pageControlHeight:Double = 16
       self.pageControl.snp.makeConstraints { (make) in
        make.bottom.right.equalTo(-10)
        make.width.equalTo(pageControlWidth)
        make.height.equalTo(pageControlHeight)
       }
    }
       
    
    //MARK:--- 重置定时器
    func resetTimer(){
        
        if self.autoRun == false {
            return
        }
        
        self.timer?.invalidate()
        
        if(self.dataArr == nil || self.dataArr!.count<2) {
            return
        }
        
        let timeInterval:Double = 2.5
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true);
       
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    @objc func timerRun() {
        guard let currentIp:IndexPath = self.collectionView.indexPathsForVisibleItems.first else{
            return
        }
        
        if currentIp.row+1 >= self.dataArr!.count+2{ return }
        
        let nextIndexPath = IndexPath(item: currentIp.row+1, section: 0)
        self.collectionView.scrollToItem(at: nextIndexPath, at: [.top,.left], animated: true)
    }
    
    //MARK:--- 刷新数据
    public func refresh() {
        self.collectionView.reloadData()
        self.resetTimer()
        if let datas = self.dataArr, datas.count>1 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.01) {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
            }
        }
    }
    
    //MARK:--- 轮播的核心 在边缘更换index
    private func transferIndex(_ index:Int) -> Int {
        if self.dataArr==nil||self.dataArr!.count<=1 {
            return 0;
        }
        if index == 0 {
            return self.dataArr!.count-1;
        }else if index == self.dataArr!.count+1 {
            return 0;
        }
        
        return index-1;
    }
    
}


class MDSCyclicCell: UICollectionViewCell {
    
    var imageView:UIImageView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        self.imageView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
