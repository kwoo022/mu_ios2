//
//  TGSMainTab.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/30.
//

import SwiftUI

extension UITabBarController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .white
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .red
        
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.tabBar.standardAppearance = appearance
        //self.tabBar.scrollEdgeAppearance = appearance
    }
}


// MARK: 탭뷰 Scene를 구성하는 뷰모델
public struct TGSTabviewSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    public var initTab : Int
    public var arrTab : [AnyView] = []
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad,
                initTab: Int, arrTab: [AnyView]) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.initTab = initTab
        self.arrTab = arrTab
    }
}


// MARK: 탭뷰 Scene (하단 탭 구성 화면)
public struct TGSTabviewScene : View {
    let TAG  = "[TGSTabviewScene]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSTabviewSceneModel
    
    // 선택 된 탭 인덱스
    @State  var selectedTabIndex : Int = 0
    @State var homeYn : Bool = true
    
    // 커맨드 형태로 탭 변경 요청이 왔을때 실행
    var tabChangeCallback:((_ commandType:Int, _ selectIndex : Binding<Int>)->Void)? = nil
    //웹 팝업 메시지 이벤트 콜백
    var webPopupCallback:((_ url:String)->Void)? = nil
    // Otp 팝업 이벤트 콜백
    var otpPopupCallback:((_ otp:String)->Void)? = nil
    // 사진업로드 팝업 이벤트 콜백
    var picturePopupCallback:(([SelectedMedia], Double, Double)->Void)? = nil

    
    // MARK: INITIALIZER
    public init(viewModel: TGSTabviewSceneModel) {
        self.viewModel = viewModel
        self.selectedTabIndex = viewModel.initTab
        
        
    }
    
    // MARK: BODY
    public var body: some View {
        TGSBaseScene(command: self.viewModel.command) {
            TabView(selection: $selectedTabIndex) {
                Group {
                    ForEach(self.viewModel.arrTab.indices, id:\.self) { index in
                        self.viewModel.arrTab[index]
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                }
            }

            .onChange(of: selectedTabIndex, perform: { selTab in
                if self.homeYn == true {
                    if self.selectedTabIndex == -1 {
                        let newCmd = "TGSFW_COMD://moveHomeReload"
                        let cmd  = TGSUCommand.convertWebCommand(newCmd)
                        self.viewModel.command.currCommand.send(cmd!)
                    }
                }else{
                    if self.selectedTabIndex == -1 {
                        self.selectedTabIndex = 0
                    }
                }
                if self.selectedTabIndex == 0 || self.selectedTabIndex == -1 {
                    self.homeYn = true
                }else{
                    self.homeYn = false
                }
            })
            
            .accentColor(Color.whiteAndBlackColor)
            .edgesIgnoringSafeArea(.top)
            .onReceive(self.viewModel.command.currCommand.receive(on: DispatchQueue.main)) { webCommand in
                TGSULog.log(TAG, "onReceive Command : ", "\(webCommand.type)", webCommand.param)
                if(self.tabChangeCallback != nil) {
                    self.tabChangeCallback!(webCommand.type, self.$selectedTabIndex)
                }
                switch webCommand.type {
                case TGSWebCommandType.WCT_MOVE_HOME.rawValue:
                    self.selectedTabIndex = 0
                case TGSWebCommandType.WCT_MOVE_NOTICE.rawValue:
                    self.selectedTabIndex = 1
                case TGSWebCommandType.WCT_MOVE_ID_CARD.rawValue:
                    self.selectedTabIndex = 2
                case TGSWebCommandType.WCT_MOVE_SETTING.rawValue:
                    self.selectedTabIndex = 3
                    
                default: break
                }
            }
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
            self.appInfo.currCommand = self.viewModel.command
            UITabBar.appearance().backgroundColor = UIColor(Color.whiteAndBlackBgColor)
        }
    }
    

    //MARK: METHOD
    /// TGSWebCommandType 타입의 rawValue 값으로 전달된다.
    public func onTabChangeCallback (_ action: @escaping (Int, Binding<Int>) -> Void) -> Self {
        var copy  = self
        copy.tabChangeCallback = action
        return copy
    }
    
    public func onWebPopupCallback(_ action: @escaping (_ url:String) -> Void) -> Self {
        var copy  = self
        copy.webPopupCallback = action
        return copy
    }
    
    public func onOtpPopupCallback(_ action: @escaping (_ otp:String) -> Void) -> Self {
        var copy  = self
        copy.otpPopupCallback = action
        return copy
    }
    
    public func onPicturePopupCallback(_ action: @escaping ([SelectedMedia], Double, Double)->Void) -> Self {
        var copy  = self
        copy.picturePopupCallback = action
        return copy
    }
    
}





//struct TGSTabviewScene_Previews: PreviewProvider {
//    static var previews: some View {
//        TGSTabviewScene(viewModel: TGSTabviewSceneModel(
//            initTab: 0,
//            arrTab: [
//                AnyView(TGSTabHome(showMenu: .constant(false),command: TGSMCommad())),
//                AnyView(TGSTabNotice(command: TGSMCommad())),
//                AnyView(TGSTabIdCard(command: TGSMCommad())),
//                AnyView(TGSTabSetting())
//            ]
//        ))
//        //TGSTabviewScene(showMenu: .constant(false), command: TGSMCommad())
//    }
//}
