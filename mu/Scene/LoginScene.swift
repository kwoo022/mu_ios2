//
//  LoginScene.swift
//  Sample
//
//  Created by idino on 2023/03/13.
//

import SwiftUI
import tgsmf_ios

struct LoginScene: View {
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSLoginSceneModel

    // 화면이동 담당 Coordinator
    @StateObject var coordinator = NavigationCoordinator(isRoot: true)
      
    
    // MARK: INITIALIZER
    init(_ viewModel : TGSLoginSceneModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        BaseNavigationView(coordinator: self.coordinator, command: self.viewModel.command) {
            TGSLoginScene(self.viewModel)
                .onLoginSuccessCallback(self.onLoginSuccess(userId:password:))
        }
        .background(Color.white)
    }
    
    func onLoginSuccess(userId:String, password:String){
        let newViewModel = TGSSidemenuSceneModel(isShowSelf: self.coordinator.getTriggerBinding(), command: TGSMCommad(), sideMenu: SideMenuScene.initSideMenu())
        self.coordinator.push(destination: .sideMeue(newViewModel))
    }
}

struct LoginScene_Previews: PreviewProvider {
    static var previews: some View {
        LoginScene(TGSLoginSceneModel(isShowSelf: .constant(true), command: TGSMCommad()))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
