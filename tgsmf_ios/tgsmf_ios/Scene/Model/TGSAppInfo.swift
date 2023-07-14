import SwiftUI

//MARK: App 실행 후 내부에서 사용되어지는 environmentObject
public class TGSAppInfo : ObservableObject {
    
    //@Published public var currState : TGS_SCENE_STATE = .launch        // 앱의 Scene 상태
    
    @Published public var showSideMenu : Bool = false                  // 사이드메뉴 표시 여부
    
    @Published public var showLoading : Bool = false                   // 로딩바 표시 여부
    
    @ObservedObject public var currCommand : TGSMCommad = TGSMCommad()                 // 현재 forgraound 화면이 구독하고 있는 command
    @ObservedObject public var currWebCommand:TGSMWebviewModel = TGSMWebviewModel()    // 현재 forgraound 화면이 구독하고 있는 web command
                                          
    public var currIsSelfShow : Binding<Bool>                           // 현재 forgraound 화면의 show 변수
 
    public init(isShowSelf:Binding<Bool>) {
        self.currIsSelfShow = isShowSelf
    }
}
