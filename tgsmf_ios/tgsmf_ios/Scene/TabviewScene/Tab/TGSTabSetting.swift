//
//  TGSTabSetting.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/30.
//

import SwiftUI
import BSImagePicker
import FirebaseMessaging

// MARK: Tab Setting 뷰모델
public struct TGSTabSettingModel : TGSSceneModel{
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    var tabIdx : Int = 0
    var tabIcon : UIImage   // R.Image.foot1
    var tabText : String? = nil
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, tabIdx: Int, tabIcon: UIImage, tabText: String? = nil) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.tabIdx = tabIdx
        self.tabIcon = tabIcon
        self.tabText = tabText
    }
}


// MARK: Tab Setting 뷰
public struct TGSTabSetting : View {
    let TAG = "[TGSTabSetting]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    // 뷰 모델
    @State var viewModel : TGSTabSettingModel
    
    // 푸시 수신 여부
    @State var isReceivePush: Bool = TGSUUserDefaults.getIsReceivePush()
    // 푸시 수신 거부 일자
    @State private var strPushDate : String = TGSUUserDefaults.getRefusePushDate()
    //로그인 계정 저장 여부
    @State var isSaveAccount: Bool = TGSUUserDefaults.getIsSaveAccount()
    
    // 로그아웃 알림
    @State private var showingLogoutPopup : Bool = false
    @State private var isLogout: Bool = false
    
    var logoutCallback:(()->Void)? = nil
    
    // MARK: INITIALIZER
    public init(viewModel : TGSTabSettingModel) {
        self.viewModel = viewModel
    }
    
    // MARK: BODY
    public var body : some View {
        
        VStack{
            TGSVTitle(viewModel: TGSVTitleModel(isShowSelf: self.viewModel.isShowSelf, command: self.viewModel.command, type: .TITLE, title: "설정"))
            VStack{
                /// 푸시 알림 수신 여부 저장
                VStack(alignment: .leading)  {
                    HStack {
                        Image(systemName: "bell")
                            .foregroundColor(Color.whiteAndBlackColor)
                        Toggle("푸시 알림 수신", isOn: self.$isReceivePush.onChange(toggleReceivePush(isReceive:)))
                            .font(R.Font.font_noto_m(size: 14))
                            .foregroundColor(Color.whiteAndBlackColor)
                            .toggleStyle(SwitchToggleStyle(tint: Color(hex:"3dc172")))
                        
                    }
                    .foregroundColor(Color(hex: "303030"))
                    
                    if(!self.isReceivePush &&  !self.strPushDate.isEmpty) {
                        Text("수신 거부 일시 : \(strPushDate)")
                            .font(R.Font.font_gmarket_m(size: 14))
                            .foregroundColor(Color.red)
                            .padding(.leading, 28)
                    }
                }
                .padding(.vertical, 8)
                
                /// 로그인 정보 자동 저장
                Divider()
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(Color.whiteAndBlackColor)
                    Toggle("로그인 정보 자동 저장", isOn: self.$isSaveAccount.onChange(toggleSaveAccount(isSave:)))
                        .font(R.Font.font_noto_m(size: 14))
                        .foregroundColor(Color.whiteAndBlackColor)
                        .toggleStyle(SwitchToggleStyle(tint: Color(hex:"3dc172")))
                    
                }
                .foregroundColor(Color(hex: "303030"))
                .padding(.vertical, 8)
                Divider()
                
                Spacer()
                
                if(TGSUUserDefaults.getIsSaveLogout() == "true" || TGSUUserDefaults.getIsSaveLogout() == ""){
                    /// 계정 로그아웃
                    NavigationLink (destination: TGSLoginScene(TGSLoginSceneModel(isShowSelf: self.$isLogout, command: TGSMCommad())), isActive: self.$isLogout) {
                        Button(action: { requestLogin() }) {
                            Text("로그인")
                                .font(R.Font.font_noto_r(size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 45)
                        }
                    }
                    .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: R.Color.color_login_button_bg, cornerRadius: 10))
                    .padding(.top, 32)
                }else{
                    /// 계정 로그아웃
                    NavigationLink (destination: TGSLoginScene(TGSLoginSceneModel(isShowSelf: self.$isLogout, command: TGSMCommad())), isActive: self.$isLogout) {
                        Button(action: { requestLogout() }) {
                            Text("계정 로그아웃")
                                .font(R.Font.font_noto_r(size: 14))
                                .frame(maxWidth: .infinity, maxHeight: 45)
                        }
                    }
                    .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: R.Color.color_login_button_bg, cornerRadius: 10))
                    .padding(.top, 32)
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
        }
        .popup(isPresented: $showingLogoutPopup) {
            TGSVPopup(messsage: "로그아웃하시겠습니까?", title: "로그아웃", messageType: .nomal, type: .okCancel, okCallback: self.onLogout, cancelCallback: {self.showingLogoutPopup=false})
            
        }
        .tag(self.viewModel.tabIdx)
        .tabItem {
            Text(self.viewModel.tabText ?? "")
            TGSVImage(self.viewModel.tabIcon)
        }
        .onAppear{
            isReceivePush = TGSUUserDefaults.getIsReceivePush()
            strPushDate = TGSUUserDefaults.getRefusePushDate()
            isSaveAccount = TGSUUserDefaults.getIsSaveAccount()
        }
        
    }
}

//MARK: METHOD
extension TGSTabSetting {
    
    // 푸시 알림 수신 토글 변경
    private func toggleReceivePush(isReceive : Bool) {
        TGSULog.log(TAG, "푸시 알림 수신 여부 변경 : \(isReceive)")

        if(!isReceive) {
            let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 2020-08-13 16:30
            //let str = dateFormatter.string(from: nowDate)
            strPushDate = dateFormatter.string(from: nowDate)
        } else {
            strPushDate = ""
        }
        
        
        var userPushFg = "N"
        if isReceive {
            userPushFg = "Y"
        }
        
        
        let param = ["userPushFg" : userPushFg]
        TGSURest.shared.POST(url: TGSMConst.Url.PUSH_FG_SAVE_URL, params: param, isSaveCookies: true,
            onSuccess: { result in
                TGSULog.log(TAG, TGSMConst.Url.PUSH_FG_SAVE_URL+" - ","성공 : \(result)")
                TGSULog.log(TAG, TGSMConst.Url.PUSH_FG_SAVE_URL+" - ","성공 : \(result.result)")
                var jsonObj : Dictionary<String, Any> = [String : Any]()
            
                let userFg = result.result?.userFg!
                
                TGSUUserDefaults.setIsReceivePush(isReceive)
                TGSUUserDefaults.setRefusePushDate(strPushDate)
                
            
                // 푸시 수신 일시 : 주제 재생성
                // 푸시 미수신 일시 : 주제 삭제
                if isReceive {
                    Messaging.messaging().subscribe(toTopic: "ios_all")
                    Messaging.messaging().subscribe(toTopic: "ios_"+userFg!)
                }else{
                    //푸시 알림 미수신이면 토픽값을 제거하여 토픽으로 푸시발송 안되도록 작업
                    Messaging.messaging().unsubscribe(fromTopic: "ios_all")
                    Messaging.messaging().unsubscribe(fromTopic: "ios_"+userFg!)
                }
            
                self.appInfo.showLoading = false
            },
            onFail: { result in
                TGSULog.log(TAG, TGSMConst.Url.PUSH_FG_SAVE_URL+" - ","실패 : \(result.message)")
            }
        )
    }
    
    // 로그인 정보 자동 저장 토글 변경
    private func toggleSaveAccount(isSave : Bool) {
        TGSULog.log(TAG, "로그인 정보 저장 여부 변경 : \(isSave)")
        TGSUUserDefaults.setIsSaveAccount(isSave)
    }

    // 로그아웃 버튼 클릭 이벤트
    private func requestLogout() {
        self.showingLogoutPopup = true
    }
    
    // 로그인 버튼 클릭 이벤트
    private func requestLogin() {
        self.viewModel.command.currCommand.send(TGSMComm(type: TGSWebCommandType.WCT_MOVE_LOGIN.rawValue))
    }

    // 로그인 화면으로 이동한다.
    private func onLogout() {
        self.showingLogoutPopup = false
        
        // 팝업이 사라지고 잠시 뒤에 로그인창으로 이동하게 한다.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            // 1초 후 실행될 부분
            if(self.logoutCallback != nil) {
                self.logoutCallback!()
            } else {
                //로그아웃 커맨드를 날린다.
                self.viewModel.command.currCommand.send(TGSMComm(type: TGSWebCommandType.WCT_ACTION_LOGOUT.rawValue))
            }
            //self.appInfo.currState = .login
        }
        
    }
    
    public func onLogoutCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.logoutCallback = action
        return copy
    }

}


//MARK: PREVIEWS
struct TGSTabSetting_Previews: PreviewProvider {
    static var previews: some View {

        TabView() {
            Group {
                TGSTabSetting(viewModel: TGSTabSettingModel(isShowSelf: .constant(true), command: TGSMCommad(), tabIdx: 0, tabIcon: R.Image.foot4))
            }
        }
    }
}



