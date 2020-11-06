//
//  MDSPickImgController.swift
//  MDS
//
//  Created by rainsoft on 2020/11/2.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import Photos

class MDSPickImgController: MDSBaseController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //默认每行现实几个
    let numForRow:Int = 4
    
    //取得的照片资源结果，用了存放的PHAsset ---
    var assetsFetchResults:PHFetchResult<PHAsset>?
    
    //带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    //缩略图大小
    var assetThumbnailSize:CGSize!
    
    //默认每次最多可选择的照片数量
    var maxSelected:Int = 6
    
    //照片选择完毕后的回调
    var completeHandler:((_ imgs:[UIImage])->())?
    
    var selectedIndexPathArr:[IndexPath] = []
    
    //完成按钮
    var completeButton:UIButton = {
        let temp:UIButton = UIView.createBtn(title: "完成", titleColor: .white, fontSize: 15)
        temp.addTarget(self, action: #selector(completeButtonClick), for: .touchUpInside)
        temp.titleLabel?.font = kBloldFont(15)
        temp.backgroundColor = .green
        return temp
    }()
    
    //预览按钮
    var lookButton:UIButton = {
        let temp:UIButton = UIView.createBtn(title: "   预览", titleColor: .white, fontSize: 14)
        temp.addTarget(self, action: #selector(lookSelectedImg), for: .touchUpInside)
        temp.contentHorizontalAlignment = .left
        return temp
    }()
    
    lazy var toolBar:UIView = {
        let temp = UIView.createView(backgroundColor: .black)
        let h:CGFloat = CGFloat(49+SAFE_AREA_Height)
        temp.myFrame(0, SCREEN_HEIGHT-h, SCREEN_WIDTH, h)
        temp.addSubview(completeButton)
        completeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(temp.snp_centerY).offset(-SAFE_AREA_Height)
            make.size.equalTo(CGSize.init(width: 68, height: 34))
        }
        completeButton.cornerRadius(cornerRadius: 3)
        
        temp.addSubview(lookButton)
        lookButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(temp.snp_centerY).offset(-SAFE_AREA_Height)
            make.size.equalTo(CGSize.init(width: 68, height: 34))
        }
        return temp
    }()
    
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init();
        let itemW:CGFloat = SCREEN_WIDTH/CGFloat(self.numForRow)
        layout.itemSize = CGSize(width: itemW, height: itemW);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .vertical;
        
        let collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.myFrame(0, self.myNavView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.toolBar.height-NAV_BAR_HEIGHT)
        collection.delegate = self
        collection.allowsMultipleSelection = true
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(MDSImgCollectionwCell.self, forCellWithReuseIdentifier: "MDSImgCollectionwCell")
        collection.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
       //根据单元格的尺寸计算我们需要的缩略图大小
       let scale = UIScreen.main.scale
       self.assetThumbnailSize = CGSize(width: itemW*scale ,
                                       height: itemW*scale)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
        self.view.backgroundColor = UIColorFromRGBAlpha(0x333333,0.8)
        //初始化和重置缓存
        self.resetCachedAssets()
        self.view.addSubViews([self.collectionView,self.toolBar])
    }
    
    func setNavBar(){
        self.myNavView.backgroundColor = UIColorFromRGB(0x333333)
        self.addTitle(title: "相册")
        self.titleLab.textColor = .white
        self.addRightNav(title: "取消")
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager = PHCachingImageManager()
        self.imageManager.stopCachingImagesForAllAssets()
    }
   
    //MARK: ---取消
    @objc override func rightBtnClick(){
        if (self.presentingViewController != nil) {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: ---预览
    @objc func lookSelectedImg(){
        let imgArr = self.getAsserToImgArr()
        if imgArr.count > 0 {
            let vc:MDSBrowsePhotoController = MDSBrowsePhotoController.init()
            vc.imgArr = self.getAsserToImgArr()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            UIView.showTipsText("请选择图片")
        }
        
    }
    
    
    //MARK: ---完成
    @objc func completeButtonClick(){
        self.completeHandler?(self.getAsserToImgArr())
        DispatchQueue.main.async{
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: ---转换选中的图片 PHAsset--->img
    func getAsserToImgArr() -> [UIImage] {
        var imgArr:[UIImage] = []
        for indexPath in self.selectedIndexPathArr {
            let assert:PHAsset = self.assetsFetchResults![indexPath.row]
            MDSChoseImgsTool.manger.getAssetOrigin(asset: assert) { (img, info) in
                if img != nil {
                    imgArr.append(img!)
                }
            }
        }
        return imgArr
    }
    
    //状态栏白色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    
    //MARK: --- collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "MDSImgCollectionwCell";
        let cell:MDSImgCollectionwCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MDSImgCollectionwCell
        
        if let index = self.selectedIndexPathArr.firstIndex(of: indexPath) {
            //已经选中
            cell.changeViewBy(index+1,true)
        }else{
            cell.changeViewBy(0,false)
        }
        
        let asset = self.assetsFetchResults![indexPath.row]
        
        //获取缩略图
        self.imageManager.requestImage(for: asset, targetSize: assetThumbnailSize,
                                      contentMode: .aspectFit, options: nil) {
                                       (image, nfo) in
           cell.imgV.image = image
        }
        return cell
    }
    
    //单元格选中响应
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedIndexPathArr.contains(indexPath) {
            //取消选中
            self.selectedIndexPathArr.removeAll(where: { $0  == indexPath })
        }else{
            //获取选中的数量
            let count = self.selectedIndexPathArr.count
            //如果选择的个数大于最大选择数
            if count >= self.maxSelected {
                //弹出提示
                let title = "你最多只能选择\(self.maxSelected)张照片"
                let alertController = UIAlertController(title: title, message: nil,
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel,
                                                 handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                //添加选中
                self.selectedIndexPathArr.append(indexPath)
            }
        }
        
        //可以解决刷新闪动的问题
        CATransaction.setDisableActions(true)
        collectionView.reloadData()
        CATransaction.commit()
    }
}
