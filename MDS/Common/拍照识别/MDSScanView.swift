//
//  MDSScanView.swift
//  MDS
//
//  Created by rainsoft on 2020/11/20.
//  Copyright © 2020 jzt. All rights reserved.
//

import Foundation
import AVFoundation
import CoreMotion
class MDSScanView: UIView, AVCapturePhotoCaptureDelegate {
    
    //负责输入和输出设备之间的数据传递
    var captureSession:AVCaptureSession?
    //照片输出流
    var captureOutput:AVCapturePhotoOutput?
    //负责从AVCaptureDevice获得输入数据
    var captureDevice:AVCaptureDevice?
    //图像预览层，实时显示捕获的图像
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    var complete :((UIImage?)->())?
    
    //水平仪检测
    var motionManager:CMMotionManager = CMMotionManager.init()
    
    //layer
    var _gridLayer:MDSScanLayer = MDSScanLayer.init()
    
    lazy var centerLab:UILabel = {
        let temp = UIView.createLab(text: "平行纸面,文字对其参考线", color: .white, fontSize: 14)
        temp.textAlignment = .center
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCacmer()
        self.addLayer()
        self.checkMotion()
        self.addSubview(self.centerLab)
        self.centerLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: --- 检测水平仪
    func checkMotion(){
        self.motionManager.deviceMotionUpdateInterval = 1
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {[weak self] (motion, error) in
            
            if let mot = motion {
                let gravityX:Double = mot.gravity.x
                let gravityY:Double = mot.gravity.y
                let gravityZ:Double = mot.gravity.z
                
                //获取手机倾斜的角度
                let angle = atan2(gravityZ, sqrt(gravityX*gravityX+gravityY*gravityY))/Double.pi*180
                print("angle===\(angle)")
                
                if angle < -80 && angle > -90 {
                    //在水平面
                    UIView.dismissHud()
                    self?.centerLab.isHidden = false
                }else {
                    UIView.showText("请水平拍照,识别更准确")
                    self?.centerLab.isHidden = true
                }
            }
        }
    }
    
    //MARK: --- 初始化相机
    func initCacmer() {
        self.captureSession = AVCaptureSession()
        self.captureSession?.sessionPreset = .inputPriority
        
        self.captureDevice = AVCaptureDevice.default(for: .video)
        if let dev = captureDevice {
            let input = try? AVCaptureDeviceInput(device: dev)
            if let inp = input {
                //连接输入会话
                if (self.captureSession?.canAddInput(inp))! {
                    self.captureSession?.addInput(inp)
                }
            }
        }
        
        //连接输出会话
        self.captureOutput = AVCapturePhotoOutput()
        if #available(iOS 10.0, *) {
            if (self.captureSession?.canAddOutput(self.captureOutput!))! {
                self.captureSession?.addOutput(self.captureOutput!)
            }
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.previewLayer?.frame = self.bounds
        self.previewLayer?.videoGravity = .resizeAspectFill
        
        self.layer.insertSublayer(self.previewLayer!, at: 0)
        
        self.captureSession?.startRunning()
    }
    
    //拍照
    @objc func startCamera(){
        if #available(iOS 10.0, *) {
            var photoSetting : AVCapturePhotoSettings?
            if #available(iOS 11.0, *) {
                photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
            } else {
                photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
            }
            
            if let setting = photoSetting{
                (self.captureOutput)?.capturePhoto(with: setting, delegate: self)
            }
            
        }
    }
    
    //MARK: --- 拍照回调
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        self.captureSession!.stopRunning()
        
        let imageData = photo.fileDataRepresentation()
        
        if let imd = imageData {
            
            self.motionManager.stopDeviceMotionUpdates()
            
            let image:UIImage = UIImage(data:imd)!
            
            self.complete!(image.fixOrientation())

        }
    }
    
    //MARK: --- 横线
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .white
        self._gridLayer.setNeedsDisplay()
    }
    
    func addLayer() {
        _gridLayer.frame = self.bounds
        self.layer.addSublayer(_gridLayer)
    }
    
    deinit {
        self.motionManager.stopMagnetometerUpdates()
        self.motionManager.stopDeviceMotionUpdates()
        print("dealloc++++++++++")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class MDSScanLayer: CALayer {
    override func draw(in context: CGContext) {
        
        let rct:CGRect = self.bounds
        //填充色
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(rct)
        
        //截图范围
        context.clear(rct)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(1)
        
        context.beginPath()
    
        //画竖线
        let dw:CGFloat = (rct.size.width)/3
        for i:Int in 1..<4 {
            context.move(to: CGPoint.init(x: rct.origin.x+CGFloat(i)*dw, y: rct.origin.y))
            context.addLine(to: CGPoint.init(x: rct.origin.x+CGFloat(i)*dw, y: rct.origin.y+rct.size.height))
        }
        
        //画横线
        let dh:CGFloat = (rct.size.height)/3
        for i:Int in 1..<4 {
            context.move(to: CGPoint.init(x: rct.origin.x, y: rct.origin.y+CGFloat(i)*dh))
            context.addLine(to: CGPoint.init(x: rct.origin.x+rct.size.width, y: rct.origin.y+CGFloat(i)*dh))
        }
        context.strokePath()
    }
}




/*

 enum UIImageOrientation : Int {
 case Up //0：默认方向
 case Down //1：180°旋转
 case Left //2：逆时针旋转90°
 case Right //3：顺时针旋转90°
 case UpMirrored //4：水平翻转
 case DownMirrored //5：水平翻转
 case LeftMirrored //6：垂直翻转
 case RightMirrored //7：垂直翻转
 }
 
 */

// 修复图片旋转
extension UIImage {
    //系统拍完照 会默认旋转90 这里做还原操作
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
        default:
            break
        }
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
}
