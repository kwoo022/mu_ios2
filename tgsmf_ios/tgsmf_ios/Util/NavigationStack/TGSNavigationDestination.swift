//
//  TGSNavigationDestination.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/12.
//

import SwiftUI



public  enum TGSNavigationDestination {
    case none
    case launch(TGSLaunchSceneModel)
    case login(TGSLoginSceneModel)
    //case main

    @ViewBuilder
    var view: some View {
        switch self {
        case .none:
            EmptyView()
        case .launch(let viewModel):
            TGSLaunchScene(viewModel)
        case .login(let viewModel):
            TGSLoginScene(viewModel)
//        case .main:
//            TGSWebviewScene(viewModel: TGSWebviewSceneModel(titleName: "페이지", url: "http://naver.com"), isSelfShow: .constant(true))

        }
    }
}




