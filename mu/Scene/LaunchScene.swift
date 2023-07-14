import SwiftUI
import tgsmf_ios


struct LaunchScene: View {
    let TAG = "[TGSLaunchScene]"
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSLaunchSceneModel

    // 화면이동 담당 Coordinator
    @StateObject var coordinator = NavigationCoordinator()
    
    
    // MARK: INITIALIZER
    init(_ viewModel : TGSLaunchSceneModel) {
        self.viewModel = viewModel
        
    }
    
    
    //MARK: BODY
    var body: some View {
        BaseNavigationView(coordinator: self.coordinator, command: TGSMCommad()) {
            TGSLaunchScene(self.viewModel)
                .onFinishCallback {
                    /*if(TGSUUserDefaults.getIsSaveAccount() == true && TGSUUserDefaults.getIsSaveLogout() != "true"
                       && TGSUUserDefaults.getLoginId() != "" && TGSUUserDefaults.getLoginPw() != ""){
                        moveLoginScene()
                    }else{
                        //moveNextScene()
                        moveLoginScene()
                    }*/
                    
                    if(TGSUUserDefaults.getUserPushFg() == ""){
                        TGSUUserDefaults.setIsReceivePush(true)
                    }
                    moveLoginScene()
                }
        }
        .background(Color.white)
    }
    
    //MARK: METHOD
    /// 다음 화면으로 이동한다.
    func moveNextScene() {
        let newViewModel = TGSSidemenuSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad(), sideMenu: SideMenuScene.initSideMenu())
                self.coordinator.push(destination: .sideMeue(newViewModel))
    }
    func moveLoginScene(){
        let viewModel = TGSLoginSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad())
        self.coordinator.push(destination: .login(viewModel))
    }
}

//MARK: PREVIEW
struct LaunchScene_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScene(TGSLaunchSceneModel(isShowSelf: .constant(true), command: TGSMCommad()))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
