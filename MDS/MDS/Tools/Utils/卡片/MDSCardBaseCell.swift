//
//  MDSTwoSideCardBaseCell.swift
//  MDS
//
//  Created by rainsoft on 2020/11/9.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

class MDSCardBaseCell: UICollectionViewCell {
    
    //标签---标示现在在正面还是反面 true为正面,需要定义到model里面 避免复用
    var flag:Bool = true
    
    //正面
    var frontView = UIView.createView(backgroundColor: .white)
    
    //反面
    var backendView = UIView.createView(backgroundColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.backendView)
        self.addSubview(self.frontView)
        self.backendView.frame = self.bounds
        self.frontView.frame = self.bounds
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.flag {
            self.transitform(showView: self.backendView, hiddenView: self.frontView)
        }else {
            self.transitform(showView: self.frontView, hiddenView: self.backendView)
        }
        
    }
    
    func transitform(showView:UIView,hiddenView:UIView) {
        self.animateTransform(showView, hiddenView)
        self.flag = !self.flag
    }
    
    func animateExchage(_ showView:UIView,_ hiddenView:UIView)  {
        let showIndex = (showView.superview?.subviews.firstIndex(of: showView))!
        let hiddexIndex = hiddenView.superview?.subviews.firstIndex(of: hiddenView)
        UIView.beginAnimations("turnRound" , context: nil)
        UIView.setAnimationDuration(0.2)
        UIView.setAnimationCurve(.linear)
        if self.flag {
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: showView.superview!, cache: false)
        }else {
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: showView.superview!, cache: false)
        }
        self.exchangeSubview(at: showIndex, withSubviewAt: hiddexIndex!)
        UIView.commitAnimations()
    }
    
    
    func animateTransform(_ showView:UIView,_ hiddenView:UIView)  {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            //先绕y轴旋转到90度  可以隐藏两个视图
            showView.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0, 1, 0)
            hiddenView.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2), 0, 1, 0)
        }) { (finished) in
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                //再绕y轴旋转回到0度 展示需要展示的视图
                showView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
            }, completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
