import SwiftUI
import tgsmf_ios

import BetterSafariView
struct BaseNavigationView<Content>: View where Content: View {
    let TAG = "[TGSBaseScene]"
    
    // MARK: PROPERTIES
    @ObservedObject var coordinator : NavigationCoordinator
    @ObservedObject var command : TGSMCommad
    
    @StateObject var newCommand = TGSMCommad()
    
    
    
    // 로그아웃 알림
    @State private var showingLoginPopup : Bool = false
    
    @StateObject var appInfo:TGSAppInfo = TGSAppInfo(isShowSelf: .constant(true))
    
    //Toast 팝업 호출
    @State var showToast: Bool = false

    
    //메시지 팝업 호출
    @State var showMsgPopup:Bool = false
    @StateObject var msgModel = TGSMMsgPopup()
    var msgPopupCallback:((_ url:String)->Void)? = nil
    @State var msgPopupCallbackUrl : String = ""
    @State var msgPopupTitle : String = ""
    // 컨텐츠
    @ViewBuilder var  content: () -> Content
    var logoutCallback:(()->Void)? = nil
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack{
                    coordinator.navigationLinkSection()
                    self.content()
                }
                
            }
        }
  
        .popup(isPresented: $showToast, type: .floater(verticalPadding: 20), position: .top, animation: .spring(), autohideIn: 2, closeOnTap: true, closeOnTapOutside: true) {
            
            TGSVToast(message: "로그아웃에 실패하였습니다.\n다시 시도해 주시기 바랍니다.")
        }
        .popup(isPresented: $showingLoginPopup) {
            TGSVPopup(messsage: self.msgModel.message, title: self.msgModel.title, messageType: .nomal, type: .okCancel, okCallback: self.onLogin, cancelCallback: {self.showingLoginPopup=false})
            
        }
        .popup(isPresented: $showMsgPopup) {
            TGSVPopup(messsage: self.msgModel.message, title: self.msgModel.title, messageType: self.msgModel.messageType, type: self.msgModel.type, okCallback: self.onMsgPopupCallback, cancelCallback: self.onMsgPopupCancelCallback)
        }
        .onReceive(self.command.currCommand.receive(on: RunLoop.main)) { command in
            
            switch command.type {
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_MOVE_LOGIN.rawValue:
                let viewModel = TGSLoginSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad())
                self.coordinator.push(destination: .login(viewModel))
                break;
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_MOVE_LOGIN.rawValue:
                //self.coordinator.popToRoot()
                
                self.msgModel.title = (command.param["title"] ?? "로그인") as! String
                self.msgModel.message = (command.param["message"] ?? "로그인 후 확인 가능합니다.\n로그인하시겠습니까?") as! String
                
                
                self.showingLoginPopup = true
                break;
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_ACTION_LOGOUT.rawValue:
                let param = ["": ""]
                TGSURest.shared.GET(url: TGSMConst.Url.LOGOUT, params: param, isSaveCookies: true,
                                     onSuccess: { result in

                    self.appInfo.showLoading = false
                    TGSUUserDefaults.setIsSaveLogout("true")
//                                    let newViewModel = TGSSidemenuSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad(), sideMenu: SideMenuScene.initSideMenu())
//                                            self.coordinator.push(destination: .sideMeue(newViewModel))
                    let viewModel = TGSLoginSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad())
                    self.coordinator.push(destination: .login(viewModel))
                },
                                     onFail: { result in

                    self.appInfo.showLoading = false
                    self.showToast = true
                })
                break;
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_MOVE_QR_CHECK.rawValue:
                let viewModel = TGSQrScanSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand, qrScan: TGSMQrScanner(),scanCallback: (self.qrcodeCallback != nil ? self.qrcodeCallback! : {qrcode in}))
                self.coordinator.push(destination:.qrScan(viewModel))
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_MOVE_PUSH_LIST.rawValue:
                let viewModel = TGSPushSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand)
                
                self.coordinator.push(destination:.push(viewModel))
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_MOVE_WEB_CLOSE.rawValue:

                
                
                let title:String = (command.param["title"] ?? "") as! String
                let url:String = (command.param["url"] ?? "") as! String
                
                self.coordinator.push(destination: .titleWebview(TGSWebviewSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand, titleType: .CLOSE, titleName:title, url: url)))
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_MOVE_WEB_BACK.rawValue:
                let title:String = (command.param["title"] ?? "") as! String
                let url:String = (command.param["url"] ?? "") as! String
                
                self.coordinator.push(destination: .titleWebview(TGSWebviewSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand, titleType: .BACK, titleName:title, url: url)))
                break
                //----------------------------------------------------------
            case TGSWebCommandType.WCT_SHOW_DIALOG_MSG_CALLBACK_URL.rawValue:
                self.showMsgPopup = true
                if( command.param["type"] != nil ) {
                    switch command.param["type"] as! String  {
                    case "0" :
                        self.msgModel.type = .ok
                    case "1" :
                        self.msgModel.type = .okCancel
                    default:
                        self.msgModel.type = .ok
                        break
                    }
                }
                
                self.msgModel.title = (command.param["title"] ?? "") as! String
                self.msgModel.message = (command.param["message"] ?? "") as! String
                self.msgPopupTitle = (command.param["title"] ?? "") as! String
                self.msgPopupCallbackUrl = (command.param["url"] ?? "") as! String
                if( command.param["messageType"] != nil ) {
                    switch command.param["messageType"] as! String  {
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
            case TGSWebCommandType.WCT_MOVE_HOME_RELOAD.rawValue:
                self.coordinator.push(destination: .sideMeue(TGSSidemenuSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand, sideMenu: SideMenuScene.initSideMenu())))
                break
                //----------------------------------------------------------
            default:
                break;
            }
        }
    }
    
    // qr 스캔 화면을 띄울경우 결과를 받을수 있는 콜백 함수 등록
    var qrcodeCallback:((_ qrcode:String)->Void)? = nil
    public func onQrcodeCallback ( action: @escaping (_ qrcode:String) -> Void) -> Self {
        var copy  = self
        copy.qrcodeCallback = action
        return copy
    }
    
    // 로그인 화면으로 이동한다.
    private func onLogin() {
        self.showingLoginPopup = false
        
        // 팝업이 사라지고 잠시 뒤에 로그인창으로 이동하게 한다.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            // 1초 후 실행될 부분

            //로그아웃 커맨드를 날린다.
            let viewModel = TGSLoginSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad())
            self.coordinator.push(destination: .login(viewModel))
            
        }
        
    }
    
    public func onMsgPopupCallback( ){
        self.showMsgPopup = false

        
        self.coordinator.push(destination: .titleWebview(TGSWebviewSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: newCommand, titleType: .CLOSE, titleName:self.msgPopupTitle, url: self.msgPopupCallbackUrl)))
    }
    
    public func onMsgPopupCancelCallback(){
        self.showMsgPopup = false
        TGSUUserDefaults.setIsSaveLogout("true")
                        let newViewModel = TGSSidemenuSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad(), sideMenu: SideMenuScene.initSideMenu())
                                self.coordinator.push(destination: .sideMeue(newViewModel))
    }
    
}
