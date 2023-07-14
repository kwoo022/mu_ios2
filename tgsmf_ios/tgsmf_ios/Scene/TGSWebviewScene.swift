//
//  TGSWebviewScene.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/04.
//

import SwiftUI

// MARK: Webview 화면뷰모델
public struct TGSWebviewSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    var titleType:TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.BACK_CLOSE
    var titleName:String = ""
    var url:String = ""
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, titleType: TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.BACK_CLOSE, titleName: String, url: String) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.titleType = titleType
        self.titleName = titleName
        self.url = url
    }
}

// MARK: Webview 화면
public struct TGSWebviewScene: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    @State var viewModel : TGSWebviewSceneModel
    //@StateObject var command : TGSMCommad = TGSMCommad()
    
    @State var titleWebviewModel :TGSVTitleWebviewModel
    
    var onBackCallback:(()->Void)? = nil
    var onCloseCallback:(()->Void)? = nil
    
    //웹 팝업 메시지 이벤트 콜백
    var webPopupCallback:((_ url:String)->Void)? = nil
    // Otp 팝업 이벤트 콜백
    var otpPopupCallback:((_ otp:String)->Void)? = nil
    // 사진업로드 팝업 이벤트 콜백
    var picturePopupCallback:(([SelectedMedia], Double, Double)->Void)? = nil
    
    
    
    // MARK: INITIALIZER
    public init(_ viewModel: TGSWebviewSceneModel) {
        self.viewModel = viewModel
        
        self.titleWebviewModel = TGSVTitleWebviewModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, titleType: viewModel.titleType, titleName: viewModel.titleName, url: viewModel.url)
    }

    
    // MARK: BODY
    public var body: some View {
        TGSBaseScene(command: self.viewModel.command) {
            TGSVTitleWebview(titleWebviewModel)
                .onBackCallback(action: self.onBackButtonClick)
                .onCloseCallback(action: self.onCloseButtonClick)
        }
        .onWebPopupCallback(action: { url in
            if(self.webPopupCallback != nil) {self.webPopupCallback!(url)}
        })
        .onOtpPopupCallback(action: { otp in
            if(self.otpPopupCallback != nil) {self.otpPopupCallback!(otp)}
        })
        .onPicturePopupCallback(action: { arrPicture, lat, lot in
            if(self.picturePopupCallback != nil) {self.picturePopupCallback!(arrPicture, lat, lot)}
        })
        .onAppear() {
            appInfo.currIsSelfShow = self.viewModel.isShowSelf
            appInfo.currCommand = self.viewModel.command
            //appInfo.currWebCommand = TGSMWebviewModel()
        }
        .onReceive(self.viewModel.command.currCommand.receive(on: RunLoop.main)) { webCommand in
            switch webCommand.type {
            default:
                break
            }
        }
        .navigationBarHidden(true)
    }
    
    
    
    // back 버튼 클릭 callback 등록
    public func onBackCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onBackCallback = action
        return copy
    }
    // close 버튼 클릭 callback 등록
    public func onCloseCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onCloseCallback = action
        return copy
    }
    
    // 타이블바의 Back 버튼을 눌렀을때
    public func onBackButtonClick() {
        if(self.onBackCallback != nil) {
            self.onBackCallback!()
        } else {
            self.viewModel.isShowSelf.wrappedValue = false
        }
        
        
    }
    // 타이블바의 Close 버튼을 눌렀을때
    public func onCloseButtonClick() {
        if(self.onCloseCallback != nil) {
            self.onCloseCallback!()
        }else {
            self.viewModel.isShowSelf.wrappedValue = false
        }
    }
    
    //웹 팝업 메시지 이벤트 콜백
    public func onWebPopupCallback ( action: @escaping (_ url:String) -> Void) -> Self {
        var copy  = self
        copy.webPopupCallback = action
        return copy
    }
    // Otp 팝업 이벤트 콜백
    public func onOtpPopupCallback ( action: @escaping (_ otp:String) -> Void) -> Self {
        var copy  = self
        copy.otpPopupCallback = action
        return copy
    }
    // 사진업로드 팝업 이벤트 콜백
    public func onPicturePopupCallback ( action: @escaping ([SelectedMedia], Double, Double) -> Void) -> Self {
        var copy  = self
        copy.picturePopupCallback = action
        return copy
    }
}

struct TGSWebviewScene_Previews: PreviewProvider {
    static var previews: some View {
        TGSWebviewScene(TGSWebviewSceneModel(isShowSelf: .constant(true), command: TGSMCommad(), titleName: "게시판", url: TGSMConst.Url.NOTICE_PAGE))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
