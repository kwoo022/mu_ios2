

import SwiftUI

// MARK: Launch 화면뷰모델
public struct TGSTabHomeModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    //하단 표시 탭 정보
    var tabIdx : Int = 0
    var tabIcon : UIImage   // R.Image.foot1
    var tabText : String? = nil
    
    var isUseMenu : Bool = true         // 메뉴 버튼 사용 여부
    var isUsePush : Bool = true         // 푸시 버튼 사용 여부
    var initUrl:String = ""             // 처음 보여지는 화면 url
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad,
                tabIdx:Int = 0, tabIcon: UIImage, tabText: String? = nil,
                isUseMenu: Bool = true, isUsePush: Bool = true, initUrl: String = "") {
        self.isShowSelf = isShowSelf
        self.command = command
        self.tabIdx = tabIdx
        self.tabIcon = tabIcon
        self.tabText = tabText
        self.isUseMenu = isUseMenu
        self.isUsePush = isUsePush
        self.initUrl = initUrl
    }
}

// MARK: Launch 화면
public struct TGSTabHome : View {
    let TAG = "[TGSTabHome]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSTabHomeModel
    
    // 커맨드 수신 객체
    //@ObservedObject var command : TGSMCommad

    
    // 읽기않은 푸시 메시지 여부
    @State  var isNotReadedPush = false
    
    // 웹뷰 모델 객체
    @State var titleWebviewModel: TGSVTitleWebviewModel
    
    var menuClickCallback:(()->Void)? = nil
    var pushClickCallback:(()->Void)? = nil
    
    
    // MARK: INITIALIZER
    public init(_ viewModel: TGSTabHomeModel) {
        self.viewModel = viewModel
        self.titleWebviewModel = TGSVTitleWebviewModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, titleType: TGSE_TITLE_TYPE.NONE, titleName: "", url: viewModel.initUrl)
        //self.command = command
    }
    
    //MARK: BODY
    public  var body : some View {
        ZStack(alignment: .topLeading){
            TGSVTitleWebview(self.titleWebviewModel)
            HStack {
                if self.appInfo.showSideMenu {Button(action: {
                        menuClickCallback?()
                        withAnimation{ self.appInfo.showSideMenu.toggle() }
                        }) {
                            TGSVImage(R.Image.menu_ic1)
                                .frame(width: 19, height: 20)
                            
                        }
                        .frame(width: 50 , height: 50)
                        .background(Color.blue.opacity(0.1))
                            
                            Spacer()
                }
                Button(action: {
                    if(pushClickCallback != nil) {
                        self.pushClickCallback!()
                    } else {
                        self.viewModel.command.currCommand.send(TGSMComm(type:TGSWebCommandType.WCT_MOVE_PUSH_LIST.rawValue))
                    }
                }) {
                    TGSVImage(self.isNotReadedPush ? R.Image.alarm2on_ic1 :  R.Image.alarm2_ic1)
                        .frame(width: 19, height: 20)
                        .position(x: 25,y: 30)
                }
                .frame(width: 50 , height: 50)
                //.background(Color.white) //Color.blue.opacity(0.1)
                
            }
            .padding(.horizontal, 5)
        }
        
        .onAppear() {
            /// 화면이 보여질때 읽지 않은 푸시 알림이 있는지 확인한다.
            let count = TGSUDBPushEntity.shared.notReadDataCount()
            self.isNotReadedPush = count > 0 ? true : false
            self.viewModel.tabIdx = -1
        }
        .tag(self.viewModel.tabIdx)
        .tabItem {
            Text(self.viewModel.tabText ?? "")
            TGSVImage(self.viewModel.tabIcon)
        }
    }
    
    //MARK: METHOD
    /// 메뉴 버튼을 눌렀을때 실행
    public func onMenuClickCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.menuClickCallback = action
        return copy
    }
    
    // 푸시 버튼을 눌렀을때 실행
    public func onPushClickCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.pushClickCallback = action
        return copy
    }
}

//MARK: PREVIEWS
struct TGSTabHome_Previews: PreviewProvider {
    static var previews: some View {
        TabView() {
            Group {
                TGSTabHome(TGSTabHomeModel(isShowSelf: .constant(true), command: TGSMCommad(),
                    tabIdx: 0, tabIcon: R.Image.foot1, initUrl: "https://naver.com"))
                    .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
            }
        }
    }
}
