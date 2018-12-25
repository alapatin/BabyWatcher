//
//  ViewController.swift
//  BabyWatcher
//
//  Created by macbook air on 25/12/2018.
//  Copyright © 2018 a.lapatin@icloud.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var discoverySession: AVCaptureDevice.DiscoverySession!
    //    var captureDevice: AVCaptureDevice?
    var cameraInput: AVCaptureDeviceInput?

    @IBOutlet weak var previewView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Find and get Camera
        
        discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
            [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                            mediaType: .video, position: .unspecified)
        func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
            let devices = discoverySession.devices
            guard !devices.isEmpty else { fatalError("Missing capture devices.")}
            return devices.first(where: { device in device.position == position })!
        }
        
        let captureDevice = bestDevice(in: .back)
        
        
        // Create Session
        
        captureSession = AVCaptureSession()
        
        // Add Camera to Input
        
        do {
            cameraInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error as NSError {
            print(error)
        }
        
        // Add Input to Session
        
        if captureSession.canAddInput(cameraInput!){
            captureSession.addInput(cameraInput!)
        } else {
            fatalError("Can't add input to the session")
        }
        
        
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
        
        
        captureSession.startRunning()
    }
    
    
}

