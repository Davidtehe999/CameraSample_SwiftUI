//
//  AVFoundationVM.swift
//  CameraSample_SwiftUI
//
//  Created by koji torishima on 2020/02/21.
//  Copyright © 2020 koji torishima. All rights reserved.
//

import UIKit
import Combine
import AVFoundation

class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate,ObservableObject {
    
    //撮影された画像
    @Published var image: UIImage?
    // プレビュー用レイヤー
    var previewLayer: CALayer!
    
    private var _takePhoto:Bool = false
    
    private let session = AVCaptureSession()
    
    private var device: AVCaptureDevice!
    
    override init() {
        super.init()
        
        
    }
    
    func takePhoto() {
        _takePhoto = true
    }
    
    private func prepareCamera() {
        session.sessionPreset = .photo
        
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            device = availableDevice
        }
    }
    
    
    private func beginSession() {
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            session.addInput(input)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer = previewLayer
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        
        session.commitConfiguration()
        
        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        output.setSampleBufferDelegate(self, queue: queue)
        
    }
    
    func startSession() {
        if session.isRunning{ return }
        session.startRunning()
    }
    
    func endSession() {
        if !session.isRunning{ return }
        session.stopRunning()
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if _takePhoto {
            _takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    
    private func getImageFromSampleBuffer(buffer: CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale,orientation: .right)
            }
        }
        return nil
        
    }
}
