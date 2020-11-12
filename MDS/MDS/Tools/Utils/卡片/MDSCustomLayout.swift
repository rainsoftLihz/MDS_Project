//
//  MDSCustomLayout.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit


class MDSCustomLayout: UICollectionViewFlowLayout {
    
    //居中卡片宽度与据屏幕宽度比例
    let CardWidthScale:CGFloat = 0.9
    let CardHeightScale:CGFloat = 1.0
    
    var itemWidth:CGFloat {
        return self.collectionView!.bounds.size.width * CardWidthScale
    }
    
    var itemHeight:CGFloat {
        return self.collectionView!.bounds.size.height * CardHeightScale
    }
    
    //设置左右缩进
    var insetX:CGFloat {
        return (self.collectionView!.bounds.size.width - self.itemWidth)/2
    }
    
    var insetY:CGFloat {
        return (self.collectionView!.bounds.size.height - self.itemHeight)/2
    }
    
    var canScaleWithScroll:Bool = true
    
    //MARK:---布局之前的初始化,只会调用一次
    override func prepare() {
        super.prepare()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10.0
        self.itemSize = CGSize.init(width: self.itemWidth, height: self.itemHeight)
        self.sectionInset = UIEdgeInsets(top: 0, left: self.insetX, bottom: 0, right: self.insetX)
    }
    
    //true:frame发生改变就重新布局,内部会重新调用prepare和layoutAttributesForElementsInRect
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if self.canScaleWithScroll == false {
            //不允许缩放
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }
        return true
    }
    
    //MARK:---用来计算出rect这个范围内所有cell的UICollectionViewLayoutAttributes，
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        //首先获取 当前rect范围内的 attributes对象
        let array = super.layoutAttributesForElements(in: rect)
        if self.canScaleWithScroll == false {
            //不允许缩放
            return array
        }
        
        
        //colleciotnView中心点的值
        let centerX =  (self.collectionView?.contentOffset.x)! + (self.collectionView?.width)!/2
        //最大移动距离
        let maxApart = ((self.collectionView?.bounds.size.width)! + self.itemWidth)/2.0
        //循环遍历每个attributes对象 对每个对象进行缩放
        for attr in array! {
            //计算每个对象cell中心点的X值
            let cell_centerX = attr.center.x
            //计算两个中心点的距离
            let distance = abs(cell_centerX-centerX)
            //移动的距离和屏幕宽度的的比例
            let apartScale:CGFloat = distance/maxApart
            if (abs(apartScale) > 1) {
                continue
            }
            //把卡片移动范围固定到 -π/8到 +π/8这一个范围内
            let scale:CGFloat = abs(cos(apartScale * CGFloat(Double.pi)/8))
            attr.transform3D = CATransform3DMakeScale(1.0, scale, 1.0)
        }
        return array
    }
}
