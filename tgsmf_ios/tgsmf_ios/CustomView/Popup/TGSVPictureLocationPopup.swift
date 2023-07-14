//
//  TGSVPictureLocationPopup.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/03.
//

import SwiftUI
import BSImagePicker
import CoreLocationUI
import Photos
import AVFoundation

public struct SelectedMedia: Identifiable {
    public var id = UUID()
    //var asset: PHAsset
    public var image: UIImage
}


public struct TGSVPictureLocationPopup : View {
    @Binding var isShowSelf : Bool

    
    @State private var showImagePicker : Bool = false
    @State private var showCameraPicker : Bool = false
    private var camera : Camera
    //@State var image: UIImage?
    
    @State var selectImage :[SelectedMedia] = []
    
    @State var isShareLocation : Bool = true
    @StateObject var locationManager = TGSULocationManager()
    
    @State var showPermissionPopup:Bool = false
    @StateObject var modelPermissionPopup = TGSMMsgPopup()
    
    @State var showMsgPopup:Bool = false
    @StateObject var modelMsgPopup = TGSMMsgPopup(message: "**현재 위치를 얻어오는데 실패했습니다.**\n**위치를 다시 검색 하시겠습니까?** \n\n(위치 정보 제외하고 싶은 경우 '현재 내 위치 공유' 체크를 해지 후 다시 시도하세요.)", type: .okCancel)
    
    var okCallback : ([SelectedMedia], Double, Double) -> ()
    var closeCallback : () -> ()
    
    
    public init(isShow : Binding<Bool>, okCallback: @escaping ([SelectedMedia], Double, Double)->() = {pictures, lat, lot in },
         closeCallback: @escaping ()->() = {} ) {
        self._isShowSelf = isShow
        
        camera = Camera()
        
        self.okCallback = okCallback
        self.closeCallback = closeCallback
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading){
                        
                        // 타이틀
                        Text("사진 업로드")
                            .font(R.Font.font_gmarket_b(size: 17))
                            .foregroundColor(Color(hex: "111111"))
                        Spacer().frame(height: 10)
                        Text("현장사진을 선택 해주세요.")
                            .font(R.Font.font_noto_r(size: 13))
                            .foregroundColor(Color(hex: "5f6268"))
                        Spacer().frame(height: 15)
                        
                        viewPickerButtons
                        viewPickerImages
                    
                        Divider().padding(.vertical, 15)
                        
                        // 위치 공유
                        Toggle(isOn: $isShareLocation) {
                            Text("현재 내 위치 공유")
                                .font(R.Font.font_noto_r(size: 13))
                                .foregroundColor(Color(hex: "111111"))
                        }.toggleStyle(TGSVCheckboxStyle(style: .circle))
                            .foregroundColor(Color(hex: "66BE79"))
                        Text("위치를 공유하지 않을 경우 현장 방문이 미완료 될 수 있습니다.")
                            .font(R.Font.font_noto_r(size: 13))
                            .foregroundColor(Color(hex: "5f6268"))
                        
                        Button(action: {  self.onUpload() }) {
                            Text("확인")
                                .font(R.Font.font_noto_r(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 45)
                        }
                        .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: Color(hex: "4066f6"), cornerRadius: 10))
                        .padding(.top, 25)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    // 닫기 버튼
                    Button(action: { self.isShowSelf = false; self.closeCallback() }) {
                        TGSVImage(R.Image.ic_close1)
                            .frame(width:17)
                    }
                }
                .padding(30)
                .frame(width: geometry.size.width)
                .background(Color.white)
                .cornerRadius(10, corners: [.topLeft, .topRight])
            }
            
        }
        .onAppear() {
                locationManager.requestLocation()
                locationManager.toggleUpdateLocation(false)
        }
        .sheet(isPresented: $showImagePicker) {
            MulitSelectImagePickerView(arrSelectImage: $selectImage)
        }
        .sheet(isPresented: $showCameraPicker) {
            ImagePickerView(sourceType: .camera) { image in
                //self.image = image
                self.selectImage.append(SelectedMedia(image: image))
            }
        }
        .popup(isPresented: self.$showMsgPopup) {
            TGSVPopup(messsage: self.modelMsgPopup.message, title: self.modelMsgPopup.title, messageType: self.modelMsgPopup.messageType, type: self.modelMsgPopup.type, okCallback: {
                self.showMsgPopup = false;
                locationManager.requestLocation()
                locationManager.toggleUpdateLocation(false)
                
            }, cancelCallback: {self.showMsgPopup=false})
        }
        .popup(isPresented: self.$showPermissionPopup) {
            TGSVPopup(messsage: self.modelPermissionPopup.message, title: self.modelPermissionPopup.title, messageType: self.modelPermissionPopup.messageType, type: self.modelPermissionPopup.type, okCallback: {
                self.showPermissionPopup = false
                
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }, cancelCallback: {self.showPermissionPopup = false })
        }
    }
    
    
    //MARK: METHOD
    private func openCamera() {
        self.showCameraPicker = true
        //camera.requestAndCheckPermissions()
    }
    
    private func openGellery() {
        self.showImagePicker = true
    }
    
    func removeSelectImageItem(at index: Int) {
        self.selectImage.remove(at: index)
    }
    
    func onUpload() {
        if(self.selectImage.count < 1) {
            return
        }
        if(isShareLocation) {
            // 검색된 위치가 있는지 확인한다.
            if(self.locationManager.location == nil) {
                self.showMsgPopup = true
                return
            }
        }
            
       onRequestUpload()
    }
    
    private func onRequestUpload() {
        let lat = self.locationManager.location?.latitude
        let lot = self.locationManager.location?.longitude
        
        self.isShowSelf = false
        self.okCallback(selectImage, lat ?? 0, lot ?? 0)
        
    }
    
    private func checkCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("Camera: 권한 허용")
                openCamera()
            } else {
                print("Camera: 권한 거부")
                DispatchQueue.main.async {
                    self.modelPermissionPopup.title = "카메라 접근 권한"
                    self.modelPermissionPopup.message = "카메라 접근 권한이 거부되어 해당 기능을 사용하실 수 없습니다. 재설정을 진행하시겠습니까?"
                    self.modelPermissionPopup.type = .okCancel
                    
                    self.showPermissionPopup = true
                }
            }
        })
    }
    
    private func checkAlbumPermission(){
        PHPhotoLibrary.requestAuthorization( { status in
            switch status{
            case .authorized:
                print("Album: 권한 허용")
                openGellery()
            case .denied, .restricted, .notDetermined:
                DispatchQueue.main.async {
                    self.modelPermissionPopup.title = "사진 접근 권한"
                    self.modelPermissionPopup.message = "사진 접근 권한이 거부되어 해당 기능을 사용하실 수 없습니다. 재설정을 진행하시겠습니까?"
                    self.modelPermissionPopup.type = .okCancel
                    
                    self.showPermissionPopup = true
                }
//            case .denied:
//                print("Album: 권한 거부")
//            case .restricted, .notDetermined:
//                print("Album: 선택하지 않음")
            default:
                break
            }
        })
    }
    
    
}

extension TGSVPictureLocationPopup {
    private var viewPickerButtons : some View {
        HStack(spacing: 0) {
            Button(action: {checkCameraPermission()}) {
                TGSVImage(R.Image.ic_camera1)
                    .frame(width: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: 90)
            .background(
                Color.white
                    .borderRadius(Color(hex: "edebeb"), width: 1, radius: 10, corners: [.topLeft, .bottomLeft])
            )
            Button(action: {checkAlbumPermission()}) {
                TGSVImage(R.Image.ic_picture1)
                    .frame(width: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: 90)
            .background(
                Color.white
                    .borderRadius(Color(hex: "edebeb"), width: 1, radius: 10, corners: [.topRight, .bottomRight])
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 15)
        
    }
    private var viewPickerImages : some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(self.selectImage, id:\.id) { object in // <-- Here
                    ZStack(alignment: .topTrailing) {
                        TGSVImage(object.image)
                            .cornerRadius(10)
                            .padding(.top, 5)
                            .padding(.trailing, 5)
                            .frame(height: 50)
                            
                            
                        Button(action: {
                            if let index = self.selectImage.firstIndex(where: {$0.id == object.id}) {
                                removeSelectImageItem(at: index) // <-- Here
                            }
                        }) {
                            TGSVImage(R.Image.ic_delete1)
                                .frame(width: 15)
                        }
                    }
                }
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: 74)
        .background(Color(hex: "edebeb").cornerRadius(10, corners: .allCorners))
        
        
    }
    
}

struct TGSVPictureLocationPopup_Previews: PreviewProvider {
    static var previews: some View {
        TGSVPictureLocationPopup(isShow: .constant(true))
    }
}
