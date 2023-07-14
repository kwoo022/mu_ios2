//
//  TabWeb.swift
//  nhu
//
//  Created by idino on 2023/06/12.
//

import SwiftUI
import tgsmf_ios

struct TabWeb: View {
    let TAG = "[TabWeb]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSTabWebModel
    
    // MARK: INITIALIZER
    init(_ viewModel: TGSTabWebModel) {
        self.viewModel = viewModel
    }
    
    //MARK: BODY
    var body: some View {
        TGSTabWeb(self.viewModel)
    }
    
    //MARK: METHOD
}
