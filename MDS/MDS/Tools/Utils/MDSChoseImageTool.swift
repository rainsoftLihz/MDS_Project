//
//  MDSChoseImageTool.swift
//  MDS
//
//  Created by rainsoft on 2020/10/28.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit

 import Photos

private let shareManger = MDSChoseImageTool()



class MDSChoseImageTool:NSObject,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    class var manger:MDSChoseImageTool{
        return shareManger
    }
    
    //当前导航
    public weak var nav:UINavigationController?
    //图片返回
    public var imageHandler:ImageHandlerBlock?
    //系统方式获取图片时, 是否允许系统编辑裁剪
    public var allowsEditing = true
    //是否系统方式获取图片
    public var isSystemType = true
    
    
    //选择图片
    public func choseImgWithSourceType(type:UIImagePickerController.SourceType) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = type
//        imagePicker.modalPresentationStyle = .fullScreen
//        imagePicker.allowsEditing = false
//        nav?.present(imagePicker, animated: true, completion: nil)
        self.getAllPhotos()
        
    }
    
    //  MARK:- 获取全部图片
    private func getAllPhotos() {
    //  注意点！！-这里必须注册通知，不然第一次运行程序时获取不到图片，以后运行会正常显示。体验方式：每次运行项目时修改一下 Bundle Identifier，就可以看到效果。
    //PHPhotoLibrary.shared().register(self)
    //  获取所有系统图片信息集合体
    let allOptions = PHFetchOptions()
    // 对内部元素排序，按照时间由远到近排序
    allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
    //图片 视频
    allOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
    //allOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
    //  将元素集合拆解开，此时 allResults 内部是一个个的PHAsset单元
    let allResults = PHAsset.fetchAssets(with:allOptions )
        //  展示图片
        //PHCachingImageManager.default().requestImage(for: allResults[0], targetSize: CGSize.zero, contentMode: .aspectFit, options: nil) { (image, dictionry: Dictionary?) in
//            self.imageHandler?(image!)
//        }
        


    //print(allResults)
    }
    
    //MARK: ----UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if self.allowsEditing {
            //允许编辑
            let vc = MDSEditImgController()
            vc._img = image
            vc.successEditBlock = {[weak self] editImg in
                self?.imageHandler?(editImg)
                picker.dismiss(animated: true, completion: nil)
            }
            picker.pushViewController(vc, animated: false)
        }else {
            if imageHandler != nil{
                imageHandler!(image ?? UIImage())
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
