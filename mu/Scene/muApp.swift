//
//  nhuApp.swift
//  nhu
//
//  Created by idino on 2023/03/27.
//

import SwiftUI
import tgsmf_ios

@main
struct muApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appInfo:TGSAppInfo = TGSAppInfo(isShowSelf: .constant(true))

    var body: some Scene {
        WindowGroup {
            LaunchScene(TGSLaunchSceneModel(isShowSelf: .constant(true), command: TGSMCommad()))
                .environmentObject(appInfo).navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
