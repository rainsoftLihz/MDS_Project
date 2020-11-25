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
import CoreMedia
import CoreVideo
import CoreImage
import ImageIO
import GLKit
import CoreGraphics

typealias CompletionHandler = (_ image: UIImage?)->()

class MDSScanView: UIView,
AVCapturePhotoCaptureDelegate,
AVCaptureVideoDataOutputSampleBufferDelegate {
    /// 开启边缘检测
    var enableBorderDetection: Bool = false
    private var coreImageContext: CIContext!
    private var renderBuffer: GLuint = GLuint()
    private var glkView: GLKView!
    private var isStopped: Bool = false
    private var timer: Timer!
    private var borderDetectFrame: Bool = false
    //最大的检测矩型方框
    private var borderDetectLastRectangleFeature: CIRectangleFeature!

    //边缘识别遮盖
    private var rectOverlay: CAShapeLayer!
    //负责输入和输出设备之间的数据传递
    private var captureSession: AVCaptureSession!
    //负责从AVCaptureDevice获得输入数据
    private var captureDevice: AVCaptureDevice!
    private var context: EAGLContext!
    //照片输出流
    private var captureOutput: AVCapturePhotoOutput!
    private var forceStop: Bool = false
    // 高精度边缘识别器
    private let highAccuracyRectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
    
    var completionHandler :CompletionHandler?
    
    //水平仪检测
    var motionManager:CMMotionManager = CMMotionManager.init()
    
    lazy var centerLab:UILabel = {
        let temp = UIView.createLab(text: "平行纸面,文字对其参考线", color: .white, fontSize: 14)
        temp.textAlignment = .center
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initCameraView()
        self.checkMotion()
        /*
        self.addSubview(self.centerLab)
        self.centerLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        */
        // 注册进入后台通知
        NotificationCenter.default.addObserver(self, selector: #selector(backgroundMode), name: UIApplication.willResignActiveNotification, object: nil)
        // 注册进入前台通知
        NotificationCenter.default.addObserver(self, selector: #selector(foregroundMode), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopGyroUpdates()
        if self.timer != nil {
            self.timer.invalidate()
        }
        print("dinit ---- \(self)")
    }
    
    @objc private func backgroundMode() {
        self.forceStop = true
    }
    
    @objc private func foregroundMode() {
        self.forceStop = false
    }
    
    //MARK: --- 开始捕获图像
    func start() {
        self.isStopped = false
        self.enableBorderDetection = true
        self.captureSession.startRunning()
        
        if self.timer != nil {
            self.timer.invalidate()
        }
        // 每隔0.85监测
        self.timer = Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(enableBorderDetectFrame), userInfo: nil, repeats: true)
        self.timer.fire()
        self.hideGLKView(hidden: false, completion: nil)
    }
    
    //MARK: --- 停止捕获图像
    func stop() {
        self.isStopped = true
        self.captureSession.stopRunning()
        self.hideGLKView(hidden: true, completion: nil)
        if (self.rectOverlay != nil) {
            // 移除识别边框
            self.rectOverlay.path = nil
        }
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopGyroUpdates()
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    
    //MARK: --- 开启边缘识别
    @objc private func enableBorderDetectFrame() {
        self.borderDetectFrame = true
    }
    
    private func createGLKView() {
        if (self.context != nil) { return }
        self.context = EAGLContext(api: .openGLES2)
        let view = GLKView(frame: self.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.context = context;
        view.contentScaleFactor = 1.0
        view.drawableDepthFormat = .format24
        self.insertSubview(view, at: 0)
        self.glkView = view
        glGenRenderbuffers(1, &renderBuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderBuffer);
        
        self.coreImageContext = CIContext(eaglContext: self.context)
        EAGLContext.setCurrent(self.context)
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
    func initCameraView() {
        
        self.createGLKView()
        
        let device = AVCaptureDevice.default(for: .video)
        if (device == nil) { return }
        
        let session =  AVCaptureSession()
        self.captureSession = session;
        session.beginConfiguration()
        self.captureDevice = device;
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            session.sessionPreset = .photo
            session.addInput(input)
            
            let dataOutput =  AVCaptureVideoDataOutput()
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_32BGRA]
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
            session.addOutput(dataOutput)
            
            self.captureOutput =  AVCapturePhotoOutput()
            session.addOutput(self.captureOutput!)
            
            let connection = dataOutput.connections.first
            connection?.videoOrientation = .portrait
            
            session.commitConfiguration()
        } catch {}
    }
    
    //隐藏glkview
    private func hideGLKView(hidden:Bool, completion: (()->())?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.glkView.alpha = hidden ? 0.0 : 1.0
        }) { (isFinish) in
            if completion != nil {
                completion!()
            }
        }
    }
    
    
    
    //MARK: --- AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if (forceStop || isStopped || !CMSampleBufferIsValid(sampleBuffer)) {
            return
        }
        
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        //开启了边缘检测
        if (enableBorderDetection) {
            //开启了边缘识别
            if (borderDetectFrame) {
                // 用高精度边缘识别器 识别特征
                let features: [CIFeature] = (highAccuracyRectangleDetector?.features(in: image))!
                // 选取特征列表中最大的矩形
                borderDetectLastRectangleFeature = biggestRectangleInRectangles(rectangles: features)
                borderDetectFrame = false
            }
            
            if (borderDetectLastRectangleFeature != nil) {
                drawBorderDetectRectWithImageRect(imageRect:image.extent, topLeft: borderDetectLastRectangleFeature.topLeft, topRight: borderDetectLastRectangleFeature.topRight, bottomLeft: borderDetectLastRectangleFeature.bottomLeft, bottomRight: borderDetectLastRectangleFeature.bottomRight)
                
            }else {
                if (rectOverlay != nil) {
                    rectOverlay.path = nil;
                }
            }
        }
        
        if (context != nil && coreImageContext != nil) {
            // 将捕获到的图片绘制进_coreImageContext
            coreImageContext.draw(image, in: bounds, from: image.extent)
            context.presentRenderbuffer(Int(GL_RENDERBUFFER))
            glkView.setNeedsDisplay()
        }
    }
    
    //MARK: --- 拍照动作
    func startCamera(){
        if #available(iOS 10.0, *) {
            var photoSetting : AVCapturePhotoSettings?
            if #available(iOS 11.0, *) {
                photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
            } else {
                photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
            }
            
            if let setting = photoSetting{
                self.captureOutput!.capturePhoto(with: setting, delegate: self)
            }
            
        }
    }
    
    //MARK: --- 拍照回调
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        self.captureSession!.stopRunning()
        
        let imageData = photo.fileDataRepresentation()
        
        if imageData != nil {
            
            if (self.enableBorderDetection) {
                var enhancedImage: CIImage = CIImage(data: imageData!)!
                // 判断边缘识别度阈值, 再对拍照后的进行边缘识别
                let rectangleFeature =  self.biggestRectangleInRectangles(rectangles: (self.highAccuracyRectangleDetector!.features(in: enhancedImage)))
                
                if (rectangleFeature != nil) {
                    enhancedImage = self.correctPerspectiveForImage(image: enhancedImage, rectangleFeature: rectangleFeature!)
                }
                
                // 获取拍照图片 --- 必须异步操作 否则内存不释放
                DispatchQueue.global(qos: .default).async {
                    UIGraphicsBeginImageContext(CGSize(width:enhancedImage.extent.size.height,height: enhancedImage.extent.size.width));
                    UIImage(ciImage: enhancedImage, scale: 1.0, orientation: .right).draw(in: CGRect(x:0, y:0, width: enhancedImage.extent.size.height, height: enhancedImage.extent.size.width))
                    
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    DispatchQueue.main.async {
                        self.stop()
                        self.completionHandler!(image!)
                    }
                }
            }else {
                self.stop()
                //未开启边缘识别，直接返回图片
                self.completionHandler!(UIImage(data: imageData!)!)
            }
        }
    }
}


//MARK: --- 识别矩阵工具
extension MDSScanView{
    
    //MARK: --- 选取feagure rectangles中最大的矩形
    func biggestRectangleInRectangles(rectangles: [CIFeature]) -> CIRectangleFeature? {
        if rectangles.count == 0 { return nil }
        
        var halfPerimiterValue: Float = 0
        var biggestRectangle: CIRectangleFeature = rectangles.first as! CIRectangleFeature
        
        for rectangle in rectangles {
            let rect: CIRectangleFeature = rectangle as! CIRectangleFeature
            let p1 = rect.topLeft
            let p2 = rect.topRight
            let width = hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
            
            let p3 = rect.topLeft
            let p4 = rect.bottomLeft
            let height = hypotf(Float(p3.x - p4.x), Float(p3.y - p4.y))
            
            let currentHalfPerimiterValue = height + width
            
            if (halfPerimiterValue < currentHalfPerimiterValue)
            {
                halfPerimiterValue = currentHalfPerimiterValue
                biggestRectangle = rect
            }
        }
        
        return biggestRectangle;
    }
    
    //MARK: ---将任意四边形转换成长方形
    func correctPerspectiveForImage(image: CIImage, rectangleFeature: CIRectangleFeature) -> CIImage {
        let rectangleCoordinates = NSMutableDictionary()
        rectangleCoordinates["inputTopLeft"] = CIVector(cgPoint: rectangleFeature.topLeft)
        rectangleCoordinates["inputTopRight"] = CIVector(cgPoint: rectangleFeature.topRight)
        rectangleCoordinates["inputBottomLeft"] = CIVector(cgPoint: rectangleFeature.bottomLeft)
        rectangleCoordinates["inputBottomRight"] = CIVector(cgPoint: rectangleFeature.bottomRight)
        return image.applyingFilter("CIPerspectiveCorrection", parameters: rectangleCoordinates as! [String : Any])
    }
    
    //MARK: --- 绘制边缘检测图层
    func drawBorderDetectRectWithImageRect(imageRect: CGRect, topLeft: CGPoint,  topRight:CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint) {
        
        if (rectOverlay == nil) {
            rectOverlay = CAShapeLayer(layer: layer)
            rectOverlay.fillRule = .evenOdd
            rectOverlay.fillColor = UIColor(red: 73/255.0, green: 130/225.0, blue: 180/255.0, alpha: 0.4).cgColor
            rectOverlay.strokeColor = UIColor.white.cgColor
            rectOverlay.lineWidth = 5.0
        }
        if (rectOverlay.superlayer == nil) {
            layer.masksToBounds = true
            layer.addSublayer(rectOverlay)
        }
        
        // 将图像空间的坐标系转换成uikit坐标系
        let featureRect = transfromRealRectWithImageRect(imageRect: imageRect, topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
        
        // 边缘识别路径
        let path = UIBezierPath()
        path.move(to: featureRect.topLeft)
        path.addLine(to: featureRect.topRight)
        path.addLine(to: featureRect.bottomRight)
        path.addLine(to: featureRect.bottomLeft)
        path.close()
        // 背景遮罩路径
        let rectPath  = UIBezierPath(rect: CGRect(x: -5, y: -5, width: frame.size.width + 10, height: frame.size.height + 10))
        rectPath.usesEvenOddFillRule = true
        rectPath.append(path)
        rectOverlay.path = rectPath.cgPath
    }
    //坐标系转换
    private func transfromRealRectWithImageRect(imageRect: CGRect, topLeft: CGPoint, topRight: CGPoint, bottomLeft:CGPoint, bottomRight: CGPoint) -> TransformCIFeatureRect {
        let previewRect = self.frame;
        return MADCGTransfromHelper.transfromRealCIRectInPreviewRect(previewRect, imageRect, topLeft, topRight, bottomLeft, bottomRight)
    }
}

struct CIFeatureRect {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint
}
typealias TransformCIFeatureRect = CIFeatureRect


//MARK: --- 坐标系转换
class MADCGTransfromHelper: NSObject {
    class func transfromRealCIRectInPreviewRect(_ previewRect: CGRect, _ imageRect:CGRect, _ topLeft:CGPoint, _ topRight:CGPoint, _ bottomLeft:CGPoint, _ bottomRight:CGPoint) -> TransformCIFeatureRect {
        return MADCGTransfromHelper.md_transfromRealRectInPreviewRect(previewRect, imageRect, false, topLeft, topRight, bottomLeft, bottomRight)
    }
    
    class func transfromRealCGRectInPreviewRect(_ previewRect: CGRect, _ imageRect: CGRect, _ topLeft: CGPoint, _ topRight: CGPoint, _ bottomLeft: CGPoint, _ bottomRight: CGPoint) -> TransformCIFeatureRect {
        return MADCGTransfromHelper.md_transfromRealRectInPreviewRect(previewRect, imageRect, true, topLeft, topRight, bottomLeft, bottomRight)
    }
    
    
    class func md_transfromRealRectInPreviewRect(_ previewRect: CGRect, _ imageRect: CGRect,  _ isUICoordinate: Bool, _ topLeft: CGPoint, _ topRight: CGPoint, _ bottomLeft: CGPoint, _ bottomRight: CGPoint) -> TransformCIFeatureRect {
        
        // find ratio between the video preview rect and the image rect; rectangle feature coordinates are relative to the CIImage
        let deltaX = previewRect.width/imageRect.width;
        let deltaY = previewRect.height/imageRect.height;
        
        // transform to UIKit coordinate system
        var transform = CGAffineTransform(translationX: 0, y: previewRect.height);
        if (!isUICoordinate) {
            transform = transform.scaledBy(x: 1, y: -1);
        }
        // apply preview to image scaling
        transform = transform.scaledBy(x: deltaX, y: deltaY);
        
        var featureRect = TransformCIFeatureRect(topLeft: .zero, topRight: .zero, bottomRight: .zero, bottomLeft: .zero)
        featureRect.topLeft = topLeft.applying(transform);
        featureRect.topRight = topRight.applying(transform);
        featureRect.bottomRight = bottomRight.applying(transform);
        featureRect.bottomLeft = bottomLeft.applying(transform);
        
        return featureRect;
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
