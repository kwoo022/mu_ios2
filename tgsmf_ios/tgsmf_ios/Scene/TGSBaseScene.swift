// 화면의 기본이 되는 화면을 구성한다
// 커맨드 기능
// alert
// loading

import SwiftUI
import Combine

struct TGSBaseScene<Content>: View where Content: View {
    let TAG = "[TGSBaseScene]"
    
    // MARK: PROPERTIES
    @ObservedObject var command : TGSMCommad
    
    //Toast 팝업 호출
    @State var showToast: Bool = false
    //@State var msgToast : String = ""
    @StateObject var toastModel = TGSMToast()
    
    //메시지 팝업 호출
    @State var showMsgPopup:Bool = false
    @StateObject var msgModel = TGSMMsgPopup()
    
    //웹 팝업 호출
    @State var showWebPopup:Bool = false
    //@State var webPopupUrl = ""
    @StateObject var webPopupUrlModel : TGSMWebPopup = TGSMWebPopup()
    @StateObject var webPopupModel:TGSMWebviewModel = TGSMWebviewModel()
    var webPopupCallback:((_ url:String)->Void)? = nil
    
    //OTP 팝업 호출
    @State var showOtpPopup:Bool = false
    @StateObject var otpModel = TGSMOtp(120)
    var otpPopupCallback:((_ otp:String)->Void)? = nil
    
    // 사진업로드 팝업 호출
    @State var showPicturePopup:Bool = false
    var picturePopupCallback:(([SelectedMedia], Double, Double)->Void)? = nil
    
    
    // 컨텐츠
    @ViewBuilder var  content: () -> Content
    
    
    //MARK: BODY
    var body: some View {
        self.content()
            .popup(isPresented: $showToast, type: .floater(verticalPadding: 20), position: .top, animation: .spring(), autohideIn: 2, closeOnTap: true, closeOnTapOutside: true) {
                
                TGSVToast(message: self.toastModel.message)
            }
            .popup(isPresented: $showMsgPopup) {
                TGSVPopup(messsage: self.msgModel.message, title: self.msgModel.title, messageType: self.msgModel.messageType, type: self.msgModel.type, okCallback: {self.showMsgPopup = false}, cancelCallback: {self.showMsgPopup=false})
            }
            .popup(isPresented: $showWebPopup, type: .floater(), position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
                TGSVWebPopup(isShow: $showWebPopup, url: self.webPopupUrlModel.url, webviewModel: self.webPopupModel, okCallback: { url in
                    if(self.webPopupCallback != nil) { self.webPopupCallback!(url) }
                })
            }
            .popup(isPresented: $showOtpPopup, type: .floater(), position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
                //otpPopupView
                TGSVOtpPopup(isShow: $showOtpPopup, otpModel: self.otpModel, okCallback: { otp in
                    if(self.otpPopupCallback != nil) { self.otpPopupCallback!(otp) }
                })
                
            }
            .popup(isPresented: $showPicturePopup, type: .floater(), position: .bottom, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
                TGSVPictureLocationPopup(isShow: $showPicturePopup,
                                         okCallback: self.picturePopupCallback ?? {arrPicture, lat, lot in },
                                         closeCallback: { })
            }
        
       
        .onAppear{
            TGSULog.log(TAG, "onAppear")
        }
        .onDisappear {
            TGSULog.log(TAG, "onDisappear")
        }
        .onReceive(self.command.currCommand.receive(on: RunLoop.main)) { webCommand in
            
            TGSULog.log(TAG, "onReceive Command : ", "\(webCommand.type)", webCommand.param)
            
            switch webCommand.type {
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_TOAST.rawValue:
                let msg = (webCommand.param["message"] ?? "") as? String
                self.toastModel.message = msg!
                self.showToast = true
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_MSG.rawValue:
                self.showMsgPopup = true
                msgModel.type = .ok
                msgModel.title = (webCommand.param["title"] ?? "") as! String
                msgModel.message = (webCommand.param["message"] ?? "") as! String
                
                if( webCommand.param["type"] != nil ) {
                    switch webCommand.param["type"] as! String  {
                    case "0" :
                        msgModel.messageType = .nomal
                    case "1" : msgModel.messageType = .success
                    case "2" : msgModel.messageType = .error
                    default:
                        msgModel.messageType = .nomal
                        break
                    }
                }
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_WEB.rawValue:
                let url = (webCommand.param["url"] ?? "") as! String
                if(url.isEmpty) { return }
                
                self.webPopupUrlModel.url = url
                self.showWebPopup = true
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_OTP.rawValue:
                if( webCommand.param["limit_time"] != nil ) {
                    self.otpModel.limitTime = Int(webCommand.param["limit_time"] as! String)!
                }
                self.otpModel.startTimer()
                self.showOtpPopup = true
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_PICTURE_UPLOAD.rawValue:
                self.showPicturePopup = true
                break
//                //----------------------------------------------------------
//            case TGSWebCommandType.WCT_MOVE_QR_CHECK.rawValue:
//                self.isQrScaneview = true
//                break
//                //----------------------------------------------------------
//            case TGSWebCommandType.WCT_MOVE_PUSH_LIST.rawValue:
//                self.isPushScaneview = true
//                break
//                //----------------------------------------------------------
//                //"TGSFW_COMD://webClose?title=출석체크&url="+"\(TGSMConst.Url.BASE_URL)/attendanceView".urlEncoding()),
//            case TGSWebCommandType.WCT_MOVE_WEB_CLOSE.rawValue:
//                self.titleWebviewModel.isShowSelf = self.$isTitleWebview
//                self.titleWebviewModel.titleType = .CLOSE
//                self.titleWebviewModel.titleName = (webCommand.param["title"] ?? "") as! String
//                self.titleWebviewModel.url = (webCommand.param["url"] ?? "") as! String
//
//                self.isTitleWebview = true
//                break
//                //----------------------------------------------------------
//                //"TGSFW_COMD://webBack?title=공지사항&url="+"\(TGSMConst.Url.BASE_URL)/noticeView".urlEncoding())
//            case TGSWebCommandType.WCT_MOVE_WEB_BACK.rawValue:
//                self.titleWebviewModel.isShowSelf = self.$isTitleWebview
//                self.titleWebviewModel.titleType = .BACK
//                self.titleWebviewModel.titleName = (webCommand.param["title"] ?? "") as! String
//                self.titleWebviewModel.url = (webCommand.param["url"] ?? "") as! String
//
//                self.isTitleWebview = true
//                break
            default: break
                
            }
            
        }
    }
    
    
    //MARK: METHOD
    public func onWebPopupCallback ( action: @escaping (_ url:String) -> Void) -> Self {
        var copy  = self
        copy.webPopupCallback = action
        return copy
    }
    
    public func onOtpPopupCallback ( action: @escaping (_ otp:String) -> Void) -> Self {
        var copy  = self
        copy.otpPopupCallback = action
        return copy
    }
    
    public func onPicturePopupCallback ( action: @escaping ([SelectedMedia], Double, Double) -> Void) -> Self {
        var copy  = self
        copy.picturePopupCallback = action
        return copy
    }
    
}



