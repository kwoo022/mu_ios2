import SwiftUI
import BetterSafariView
import Combine
import FirebaseMessaging

//MARK: 로그인 화면을 구성하는 뷰모델
// 로그인 화면 생성 시 모델 데이터를 함께 넘긴다.
public struct TGSLoginSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    public var command: TGSMCommad
    
    // 로그인 로고 이미지
    public var uiLogoImage : UIImage = R.Image.longin_logo
    
    // 로그인 정보 저장 사용 여부
    public var useSaveAccount:Bool = true
    // 사용자 계정 찾기 기능 사용 여부
    public var useFindAccount:Bool = true
    // 아이디 찾기 웹 url
    public var urlFindId:String = TGSMConst.Url.BASE_URL+"/app/findid"
    // 비번 찾기 웹 url
    public var urlFindPw:String = TGSMConst.Url.BASE_URL+"/app/passinit"
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, uiLogoImage: UIImage = R.Image.longin_logo, useSaveAccount: Bool = true, useFindAccount: Bool = true) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.uiLogoImage = uiLogoImage
        self.useSaveAccount = useSaveAccount
        self.useFindAccount = useFindAccount
    }
}


// MARK: Login 화면
public struct TGSLoginScene: View {
    let TAG = "[TGSLoginScene]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSLoginSceneModel
    
    // 사용자 아이디
    @State private var userId : String = ""// = TGSUUserDefaults.getLoginId()
    // 사용자 비밀번호
    @State private var password : String = ""// = TGSUUserDefaults.getLoginPw()
    // 로그인 계정 정보 저장
    @State private var checkedSaveAccount : Bool = true// = TGSUUserDefaults.getIsSaveAccount()
    
    // 아이디 찾기 show 여부
    @State private var presentFindId = false
    // 비밀번호 찾기 show 여부
    @State private var presentFindPassword = false
    
    
    var requestLoginCallback:((_ id:String, _ password:String)->Void)? = nil
    var loginSuccessCallback:((_ id:String, _ password:String)->Void)? = nil
    var loginFailCallback:((String)->Void)? = nil
    
    
    // MARK: initalize
    public init(_ viewModel:TGSLoginSceneModel) {
        self.viewModel = viewModel
    }
    
    //MARK: BODY
    public var body: some View {
        GeometryReader { geometry in
            TGSBaseScene(command: self.viewModel.command) {
                TGSVLoading(isShowing: $appInfo.showLoading) {
                    view
                }
            }
        }
        .background(Color.whiteAndGrayBgColor)
        .onAppear {
            checkedSaveAccount = TGSUUserDefaults.getIsSaveAccount()
            userId  = (checkedSaveAccount ? TGSUUserDefaults.getLoginId() : "")
            password = (checkedSaveAccount ? TGSUUserDefaults.getLoginPw() : "")
            
            self.appInfo.currIsSelfShow = self.viewModel.isShowSelf
            self.appInfo.currCommand = self.viewModel.command
        }
        
        
    }
    /// 메인뷰 객체
    public var view : some View {
        VStack {
            TGSVImage(self.viewModel.uiLogoImage)
                .frame(width: 270)
                .padding(.top, 100)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("아이디").modifier( TextLabelModifier())
                Spacer().frame(height: 10)
                TextField("ID", text: $userId).modifier(InputTextModifier())
                    .foregroundColor(Color.blue)
                Spacer().frame(height: 20)
                Text("비밀번호").modifier(TextLabelModifier())
                Spacer().frame(height: 10)
                SecureField("Password", text: $password).modifier(InputTextModifier())
                    .foregroundColor(Color.blue)
                
                
                if(viewModel.useSaveAccount) {
                    Spacer().frame(height: 22)
                    
                    Toggle(isOn: $checkedSaveAccount) {
                        Text("로그인 상태 유지").modifier(TextLabelModifier())
                    }.toggleStyle(TGSVCheckboxStyle(style: .square))
                        .foregroundColor(R.Color.color_login_toggle_bg)
                }
                
                
                Button(action: { onClickLogin() }) {
                    Text("로그인").modifier(LoginButtonTextModifier())
                }
                .frame(height: 45)
                .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: R.Color.color_login_button_bg, cornerRadius: 10))
                .padding(.top, 32)
            }
            .padding(.horizontal, 35)
            
            Spacer()
            
            if(viewModel.useFindAccount) {
                HStack(spacing: 20) {
                    Button(action: { if(!self.viewModel.urlFindId.isEmpty) {
                        print("아이디 찾기~~")
                        self.presentFindId = true
                    }  }) {
                        Text("아이디 찾기").modifier(TextLabelModifier())
                    }
                    .buttonStyle(ClickScaleButton())
                    .safariView(isPresented: $presentFindId) {
                        SafariView(
                            url: URL(string: self.viewModel.urlFindId)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.white)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    
                    Divider().frame(height: 15).background(R.Color.color_login_line)
                    Button(action: { if(!self.viewModel.urlFindPw.isEmpty) {
                        self.presentFindPassword = true
                    }  }) {
                        Text("비밀번호 찾기").modifier(TextLabelModifier())
                    }
                    .buttonStyle(ClickScaleButton())
                    .safariView(isPresented: $presentFindPassword) {
                        SafariView(
                            url: URL(string: self.viewModel.urlFindPw)!,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.white)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
                    }
                    
                    
                }.padding(.bottom, 50)
            }
        }
        .onAppear() {
            self.appInfo.currCommand = self.viewModel.command
                        if(TGSUUserDefaults.getIsSaveAccount() == true && TGSUUserDefaults.getIsSaveLogout() != "true"
               && TGSUUserDefaults.getLoginId() != "" && TGSUUserDefaults.getLoginPw() != ""){
                            onClickLogin()
            }
        }
        .navigationBarHidden(true)
    }
}

//MARK: METHOD
extension TGSLoginScene {
    
    /// 로그인 요청 시 호출 callback
    public func onRequestLoginCallback (_ action: @escaping (String, String) -> Void) -> Self {
        var copy  = self
        copy.requestLoginCallback = action
        return copy
    }
    
    /// 로그인 성공 시 호출 callback
    public func onLoginSuccessCallback (_ action: @escaping (String, String) -> Void) -> Self {
        var copy  = self
        copy.loginSuccessCallback = action
        return copy
    }
    
    /// 로그인 실패 시 호출 callback
    public func onLoginFailCallback (_ action: @escaping (String) -> Void) -> Self {
        var copy  = self
        copy.loginFailCallback = action
        return copy
    }
    
    /// 로그인 버튼을 클릭 했을때 실행
    func onClickLogin() {
        // 아이디와 비번이 입력 되었는지 확인한다.
        if(userId.isEmpty || password.isEmpty) {
            onShowErrorMessage("아이디와 비밀번호를 입력해야 합니다.")
            return
        }
        self.requestLogin()
    }
    
    /// 서버에 로그인을 요청한다.
    public func requestLogin() {
        self.appInfo.showLoading = true
        
        if(self.requestLoginCallback != nil) {
            self.requestLoginCallback!(self.userId, self.password)
        } else {
            let fcm_token = TGSUUserDefaults.getFcmToken() ?? ""
            let param = ["userId" : self.userId, "confirmNum": self.password.urlEncoding()
                         ,"userFcm":fcm_token]
            TGSURest.shared.POST(url: TGSMConst.Url.LOGIN, params: param, isSaveCookies: true,
                                 onSuccess: { result in
                TGSULog.log(TAG, "requestSuccessRes - ","성공 : \(result)")
                TGSULog.log(TAG, "requestSuccessRes - ","성공 : \(result.result)")
                var jsonObj : Dictionary<String, Any> = [String : Any]()
                
                if(result.result?.pass == "Y" && self.userId != "idino"){
                    movePass()
                }else{
                    let userFg = result.result?.userFg!
                    let userPushFg:String = String(describing: result.result?.userPushFg ?? "")
                    
                    if(userPushFg != "Y"){
                        //주제 삭제 넣어야함
                        TGSUUserDefaults.setUserPushFg(userPushFg)
                        TGSUUserDefaults.setIsReceivePush(false)
                        
                        Messaging.messaging().unsubscribe(fromTopic: "ios_all")
                        Messaging.messaging().unsubscribe(fromTopic: "ios_"+userFg!)
                    }else{
                        TGSUUserDefaults.setUserPushFg(userPushFg)
                        TGSUUserDefaults.setIsReceivePush(true)
                        
                        Messaging.messaging().subscribe(toTopic: "ios_all")
                        Messaging.messaging().subscribe(toTopic: "ios_"+userFg!)
                    }
                    onSuccessLogin()
                }
                
                self.appInfo.showLoading = false
            },
                                 onFail: { result in
                TGSULog.log(TAG, "requestSuccessRes - ","실패 : \(result.message)")
                self.appInfo.showLoading = false
                onShowErrorMessage(result.message)
            })
        }
    }
    
    // 최초 로그인 본인인증 필요
    func movePass(){
        
        if(self.checkedSaveAccount && self.viewModel.useSaveAccount) {
            TGSUUserDefaults.setLoginId(userId)
            TGSUUserDefaults.setLoginPw(password)
        } else {
            TGSUUserDefaults.setLoginId("")
            TGSUUserDefaults.setLoginPw("")
        }

        self.viewModel.command.currCommand.send(TGSMComm(type: TGSWebCommandType.WCT_SHOW_DIALOG_MSG_CALLBACK_URL.rawValue, param: ["type" : "0", "messageType" : "0" , "title":"본인인증", "message":"최초로그인시 본인인증이 필요합니다.\n본인인증페이지로 이동합니다.","url":TGSMConst.Url.BASE_URL+"/app/nicecheck"]))
        
    }
    

    /// 로그인 성공 처리 : 계정 정보 저장 및 메인화면으로 이동
    func onSuccessLogin() {
        TGSUUserDefaults.setIsSaveLogout("false")
        // 계정 정보 저장 처리
        if(self.checkedSaveAccount && self.viewModel.useSaveAccount) {
            TGSUUserDefaults.setIsSaveAccount(true)
            TGSUUserDefaults.setLoginId(userId)
            TGSUUserDefaults.setLoginPw(password)
        } else {
            TGSUUserDefaults.setIsSaveAccount(false)
            TGSUUserDefaults.setLoginId("")
            TGSUUserDefaults.setLoginPw("")
        }
        
        if(self.loginSuccessCallback != nil) {
            self.loginSuccessCallback!(self.userId, self.password)
        }
        
        
    }
    
    /// 에러 메시지 출력
    func onShowErrorMessage(_ message:String) {
        if(self.loginFailCallback != nil) {
            self.loginFailCallback!(message)
        } else {
            self.viewModel.command.currCommand.send(TGSMComm(type: TGSWebCommandType.WCT_SHOW_DIALOG_MSG.rawValue, param: ["type" : "error", "title":"로그인", "message":message]))
            //            self.appInfo.modelMessagePopup = TGSMMsgPopup(title: "로그인", message: message, messageType: .error)
            //            self.appInfo.showMessagePopup = true
        }
        
    }
}


//MARK: Custom Login View Style
extension TGSLoginScene {
    // 라벨 텍스트 스타일
    public struct TextLabelModifier : ViewModifier {
        public func body(content: Content) -> some View {
            content.font(R.Font.font_noto_r(size: 13))
                .foregroundColor(R.Color.color_login_content_text)
        }
    }
    // Input Field 텍스트 스타일
    public struct InputTextModifier : ViewModifier {
        public func body(content: Content) -> some View {
            content.autocapitalization(.none) // 첫글자 자동 대문자 변경 방지
                .font(R.Font.font_gmarket_b(size: 16))
                .frame(height: 40)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(R.Color.color_login_input_border, lineWidth: 1)
                        .background(R.Color.color_login_input_bg.cornerRadius(10))
                )
        }
    }
    // 로그인 버튼 텍스트 스타일
    public struct LoginButtonTextModifier : ViewModifier {
        public func body(content: Content) -> some View {
            content.font(R.Font.font_gmarket_m(size: 15))
                .frame(maxWidth: .infinity, maxHeight: 45)
        }
    }
}

//MARK: PREVIEWS
public struct TGSLoginScene_Previews: PreviewProvider {
    public static var previews: some View {
        TGSLoginScene(TGSLoginSceneModel(isShowSelf: .constant(true), command: TGSMCommad()))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
