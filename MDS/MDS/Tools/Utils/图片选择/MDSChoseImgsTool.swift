//
//  MDSChoseImgsTool.swift
//  MDS
//
//  Created by rainsoft on 2020/11/2.
//  Copyright © 2020 jzt. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
struct MDSImageAlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源
    var fetchResult:PHFetchResult<PHAsset>
}

private let shareManger = MDSChoseImgsTool()
//单张图片返回
typealias ImageHandlerBlock = (_ img:UIImage)->Void
//多张图片返回
typealias ImgArrHandlerBlock = (_ imgArr:[UIImage])->Void

@objc protocol MDSChoseImgsToolDelegate : NSObjectProtocol {
    // MARK:---拍照
    func didTakePhohtoBack(img:UIImage)
    // MARK:---选择照片
    func didSelectPhohtosBack(imgArr:[UIImage])
}


class MDSChoseImgsTool: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //相簿列表项集合
    var items:[MDSImageAlbumItem] = []
    
    //当前导航
    public weak var superVC:(MDSChoseImgsToolDelegate & UIViewController)?

    //系统方式获取图片时, 是否允许系统编辑裁剪
    public var allowsEditing = true
    //最多可选
    public var maxSelected = 6
    //单例
    class var manger:MDSChoseImgsTool{
        return shareManger
    }
    
    //MARK: --- 选择图片入口
    func choseImg<R:MDSChoseImgsToolDelegate & UIViewController>(superVC:R) {
        self.superVC = superVC
        let arr:[String] = ["拍照","从手机相册选择"]
        MDSSlectTabController.showWith(superVC, titleArr: arr) { (str) in
            if str == "拍照" {
                self.goCamera()
            }else if str == "从手机相册选择" {
                self.chosePhotes()
            }
        }
    }
    
    //MARK: ---- 拍照获取照片
    func goCamera(){
        self.authorizeCamaro { (status) in
            if status != .authorized {
                return
            }
            DispatchQueue.main.async{
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = true
                cameraPicker.sourceType = .camera
                self.superVC!.present(cameraPicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        self.superVC?.didTakePhohtoBack(img: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ---- 相册获取照片
    func chosePhotes()  {
        //申请权限
        self.authorize { (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有系统的智能相册
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                      subtype: .albumRegular,
                                                                      options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            //列出所有用户创建的相册
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections
                as! PHFetchResult<PHAssetCollection>)
            
            //相册按包含的照片数量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            DispatchQueue.main.async{
                if self.items.count > 0{
                    let picVC = MDSPickImgController.init()
                    picVC.assetsFetchResults = MDSChoseImgsTool.manger.photes()
                    picVC.completeHandler = { (imgArr) in
                        self.superVC?.didSelectPhohtosBack(imgArr: imgArr)
                    }
                    let nav:MDSNavController = MDSNavController.init(rootViewController: picVC)
                    nav.modalPresentationStyle = .overFullScreen
                    self.superVC!.present(nav, animated: true, completion: nil)
                }else {
                    
                }
            }
        }
    }
    
    //MARK: ---- 拍照获取照片
    
    
    
    func photes() -> PHFetchResult<PHAsset>? {
        if self.items.count > 0 {
            return self.items.first!.fetchResult
        }
        return nil
    }
    
    
    //MARK: ---- 转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            //获取出但前相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinse(title: c.localizedTitle)
                items.append(MDSImageAlbumItem(title: title,
                                               fetchResult: assetsFetchResult))
            }
        }
    }
    
    //由于系统返回的相册集名称为英文，我们需要转换为中文
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢动作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "个人收藏"
        } else if title == "Recently Deleted" {
            return "最近删除"
        } else if title == "Videos" {
            return "视频"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "屏幕快照"
        } else if title == "Camera Roll" {
            return "相机胶卷"
        }
        return title
    }
    
    
    
    //MARK: ----获取缩略图方法
    func getAssetThumbnail(targetSize:CGSize,asset:PHAsset,dealImageSuccess:@escaping (UIImage?,[AnyHashable:Any]?) -> ()) -> Void {
        let imageSize: CGSize?
        if targetSize.width < SCREEN_WIDTH && targetSize.width < 600 {
            imageSize = CGSize(width: targetSize.width*UIScreen.main.scale, height: targetSize.height*UIScreen.main.scale)
        } else {
            let aspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
            var pixelWidth = targetSize.width * UIScreen.main.scale * 1.5;
            // 超宽图片
            if (aspectRatio > 1.8) {
                pixelWidth = pixelWidth * aspectRatio
            }
            // 超高图片
            if (aspectRatio < 0.2) {
                pixelWidth = pixelWidth * 0.5
            }
            let pixelHeight = pixelWidth / aspectRatio
            imageSize = CGSize(width:pixelWidth, height:pixelHeight)
        }
        //获取缩略图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions() //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.resizeMode   = .fast
        option.isNetworkAccessAllowed = false
        manager.requestImage(for: asset, targetSize:imageSize!, contentMode: .aspectFill, options: option) { (thumbnailImage, info) in
            dealImageSuccess(thumbnailImage,info)
        }
    }
    
    //MARK: ---获取原图的方法
    func getAssetOrigin(asset:PHAsset,dealImageSuccess:@escaping (UIImage?,[AnyHashable:Any]?) -> ()) -> Void {
        //获取原图
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        //可以设置图像的质量、版本、也会有参数控制图像的裁剪
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (originImage, info) in
            dealImageSuccess(originImage,info)
        }
    }
    
    
    //MARK: --- 判断照片是否存在本地
    func testImageInLocal(asset: PHAsset) -> Bool {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = false
        option.isSynchronous = true
        
        var isInLocalAblum: Bool?
        manager.requestImageData(for: asset, options: option, resultHandler: { (imageData, dataUTI, orientation, info) in
            isInLocalAblum = imageData == nil ? false:true
        })
        
        return isInLocalAblum!
    }
    
    
    //MARK: ---用户是否开启权限
    func authorize(authorizeClouse:@escaping (PHAuthorizationStatus)->()){
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized{
            authorizeClouse(status)
        } else if status == .notDetermined {
            // 未授权，请求授权
            PHPhotoLibrary.requestAuthorization({ (state) in
                DispatchQueue.main.async(execute: {
                    authorizeClouse(state)
                })
            })
            
            authorizeClouse(status)
        } else {
            let url = URL(string: UIApplication.openSettingsURLString)
            if let url = url, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options:[:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            authorizeClouse(status)
        }
    }
    
    //MARK: ---用户是否开启相机权限
    func authorizeCamaro(authorizeClouse:@escaping (AVAuthorizationStatus)->()){
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if status == .authorized{
            authorizeClouse(status)
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {  // 允许
                    authorizeClouse(.authorized)
                }
            })
        } else {
            let url = URL(string: UIApplication.openSettingsURLString)
            if let url = url, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options:[:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            authorizeClouse(status)
        }
    }
    
    //MARK: --- 保存照片权限
    func authorizeSave(authorizeClouse:@escaping (PHAuthorizationStatus)->()) {
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status == .authorized || status == .notDetermined {
                authorizeClouse(.authorized)
            } else {
                authorizeClouse(status)
            }
        })
    }
    
}
