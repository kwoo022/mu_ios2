import SwiftUI
import FirebaseMessaging
import Foundation

// MARK: Sidemenu 화면뷰모델
public struct TGSSidemenuSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject public var command: TGSMCommad
    
    // 사이드메뉴가 보여지는 방향
    public enum SIDE_MENU_DIRECTION:Int {
        case LEFT = 0, RIGHT
    }
    @State public var sideMenu :[TGSMMenu]
    @State public var sideDirection : SIDE_MENU_DIRECTION
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad,
                sideMenu: [TGSMMenu], sideDirection:SIDE_MENU_DIRECTION = SIDE_MENU_DIRECTION.LEFT) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.sideMenu = sideMenu
        self.sideDirection = sideDirection
    }
}

// MARK: Sidemenu 화면
public struct TGSSidemenuScene<Content>: View where Content: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    @State var viewModel : TGSSidemenuSceneModel
    
    //@ObservedObject var command : TGSMCommad// = TGSMCommad()
    //@State var sideMenu :[TGSMMenu]
    
    @ViewBuilder var  content: () -> Content
    
    
    // MARK: INITIALIZER
    public init(viewModel: TGSSidemenuSceneModel, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
        requestNotificationPermission()
    }
    
    // MARK: BODY
    public var body: some View {
        GeometryReader { geometry in
            TGSVSideBarStack(sidebarWidth: geometry.size.width * 0.8, showSidebar: self.$appInfo.showSideMenu, sideDirection: self.$viewModel.sideDirection) {
                /// 사이드메뉴
                TGSVSideMenu(showMenu: self.$appInfo.showSideMenu, menuList: self.viewModel.sideMenu, command: self.viewModel.command)
            } content: {
                /// 컨텐츠 화면
                self.content()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            //.edgesIgnoringSafeArea(.all)
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
        .onAppear() {
            self.appInfo.currCommand = self.viewModel.command
        }
    }
}
    //알림 권한 요청 로직
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge], completionHandler: {didAllow,Error in
            if didAllow{
                if(!TGSUUserDefaults.getFirstLogin()){
                    //첫 로그인 확인
                    TGSUUserDefaults.setFirstLogin(true)
                    
                    print("Push: 권한허용")
                    let param = ["userPushFg" : "Y"]
                    TGSURest.shared.POST(url: TGSMConst.Url.PUSH_FG_SAVE_URL, params: param, isSaveCookies: true,
                                         onSuccess: { result in
                        var jsonObj : Dictionary<String, Any> = [String : Any]()
                        
                        let userFg = result.result?.userFg!
                        
                        TGSUUserDefaults.setIsReceivePush(true)
                        
                        Messaging.messaging().subscribe(toTopic: "ios_all")
                        Messaging.messaging().subscribe(toTopic: "ios_"+userFg!)
                        
                    },
                        onFail: { result in
                        
                    })
                }
            }else{
                print("Push: 권한거부")
            }
        })
    }


//MARK: PREVIEW
//struct TGSMainScene_Previews: PreviewProvider {
//    static var previews: some View {
//        //sideMenu: SideMenuSample)
//        TGSSidemenuScene(viewModel: TGSSidemenuSceneModel(isShowSelf: .constant(true), command: TGSMCommad(), sideMenu: SideMenuSample)) {
//            Text("내용입니다.")
//            //TGSTabviewScene(showMenu: .constant(false), command: TGSMCommad())
//        }
//        .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
//    }
//}
