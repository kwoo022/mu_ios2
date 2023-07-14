//
//  Camera.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/03.
//

import SwiftUI
import AVFoundation

class Camera {
    var session = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let output = AVCapturePhotoOutput()
    
    // 카메라 셋업 과정을 담당하는 함수, positio
    func setUpCamera() {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                for: .video, position: .back) {
            do { // 카메라가 사용 가능하면 세션에 input과 output을 연결
                videoDeviceInput = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                    output.isHighResolutionCaptureEnabled = true
                    output.maxPhotoQualityPrioritization = .quality
                }
                session.startRunning() // 세션 시작
            } catch {
                TGSULog.log(error) // 에러 프린트
            }
        }
    }
    
    func requestAndCheckPermissions() {
        // 카메라 권한 상태 확인
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] authStatus in
                if authStatus {
                    DispatchQueue.main.async {
                        self?.setUpCamera()
                    }
                }
            }
        case .restricted:
            break
        case .authorized:
            // 이미 권한 받은 경우 셋업
            setUpCamera()
        default:
            // 거절했을 경우
            TGSULog.log("Permession declined")
        }
    }
    
    func openCamera(){
            TGSULog.log("")
            TGSULog.log("===============================")
            TGSULog.log("[A_Main >> openCamera() :: 카메라 열기 수행 실시]")
            TGSULog.log("===============================")
            TGSULog.log("")
            
            // [SEARCH FAST] : [카메라 호출 수행]
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    TGSULog.log("")
                    TGSULog.log("===============================")
                    TGSULog.log("[A_Main > openCamera() : 카메라 권한 허용 상태]")
                    TGSULog.log("===============================")
                    TGSULog.log("")
                    
                    // [카메라 열기 수행 실시]
                    DispatchQueue.main.async {
                        // -----------------------------------------
                        // [사진 찍기 카메라 호출]
                        let camera = UIImagePickerController()
                        camera.sourceType = .camera
                        //self.present(camera, animated: false, completion: nil)
                        // -----------------------------------------
                    }
                } else {
                    TGSULog.log("")
                    TGSULog.log("===============================")
                    TGSULog.log("[A_Main > openCamera() : 카메라 권한 거부 상태]")
                    TGSULog.log("===============================")
                    TGSULog.log("")
                }
            })
        }
}
