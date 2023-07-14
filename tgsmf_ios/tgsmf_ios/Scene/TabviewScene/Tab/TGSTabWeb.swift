//
//  TGSTabWeb.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/10.
//

import SwiftUI

// MARK: TabWeb 화면뷰모델
public struct TGSTabWebModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    var tabIdx : Int = 0
    var tabIcon : UIImage   // R.Image.foot1
    var tabText : String? = nil
    
    var titleType:TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.TITLE
    var titleName:String = ""
    var initUrl:String = ""  //TGSMConst.Url.NOTICE_PAGE
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, tabIdx: Int, tabIcon: UIImage, tabText: String? = nil, titleType: TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.TITLE, titleName: String = "", initUrl: String) {
        self.isShowSelf = isShowSelf
        self.command = command
        
        self.tabIdx = tabIdx
        self.tabIcon = tabIcon
        self.tabText = tabText
        self.titleType = titleType
        self.titleName = titleName
        self.initUrl = initUrl
    }
}

// MARK: TabWeb 화면
public struct TGSTabWeb : View {
    
    let TAG = "[TGSTabWeb]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    @State var viewModel : TGSTabWebModel
    
    // 웹뷰 모델 객체
    @State var titleWebviewModel: TGSVTitleWebviewModel

    // MARK: INITIALIZER
    public init(_ viewModel : TGSTabWebModel) {
        self.viewModel = viewModel
        
        self.titleWebviewModel =  TGSVTitleWebviewModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, titleType: viewModel.titleType, titleName: viewModel.titleName, url: viewModel.initUrl)
    }
    
    //MARK: BODY
    public var body: some View {
        VStack {
            TGSVTitleWebview(self.titleWebviewModel)
        }
        .tag(self.viewModel.tabIdx)
        .tabItem {
            Text(self.viewModel.tabText ?? "")
            TGSVImage(self.viewModel.tabIcon)
            //TGSVImage(R.Image.foot1)
        }
    }
    
    
    //MARK: METHOD
}

//MARK: PREVIEWS
struct TGSTabWeb_Previews: PreviewProvider {
    static var previews: some View {
        TGSTabWeb(TGSTabWebModel(isShowSelf: .constant(true), command: TGSMCommad(), tabIdx: 0, tabIcon: R.Image.foot2, titleName: "게시판", initUrl: TGSMConst.Url.NOTICE_PAGE))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
