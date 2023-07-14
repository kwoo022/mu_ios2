//
//  PushScene.swift
//  nhu
//
//  Created by idino on 2023/06/20.
//

import SwiftUI
import tgsmf_ios

struct PushScene: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSPushSceneModel
    @StateObject var coordinator = NavigationCoordinator()
    
    // MARK: INITIALIZER
    init(_ viewModel: TGSPushSceneModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        BaseNavigationView(coordinator: self.coordinator, command: self.viewModel.command) {
            TGSPushScene(self.viewModel)
        }
    }
}
