//
//  TGSVTitleWebview.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/28.
//

import SwiftUI
import Combine
import SwiftUIPullToRefresh

// MARK: Title Webview 화면뷰모델
public struct TGSVTitleWebviewModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    var titleType:TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.BACK_CLOSE
    var titleName:String = ""
    var url:String = ""
    
    var needWebRefresh : Bool = false
    var needWebGoBack : Bool = false
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, titleType: TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.BACK_CLOSE, titleName: String = "", url: String = "", needWebRefresh: Bool = false, needWebGoBack: Bool = false) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.titleType = titleType
        self.titleName = titleName
        self.url = url
        self.needWebRefresh = needWebRefresh
        self.needWebGoBack = needWebGoBack
    }
}


// MARK: Title Webview 화면
public struct TGSVTitleWebview: View {
    let TAG = "[TGSVTitleWebview]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    @State var viewModel : TGSVTitleWebviewModel
    @State var titleModel : TGSVTitleModel
    
    @StateObject var webviewModel = TGSMWebviewModel()
    
    // 웹뷰 로딩 여부
    @State var isLoading : Bool = false

    var onBackCallback:(()->Void)? = nil
    var onCloseCallback:(()->Void)? = nil
    
    // MARK: INITIALIZER
    public init(_ viewModel: TGSVTitleWebviewModel) {
        self.viewModel = viewModel
        self.titleModel = TGSVTitleModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, type: viewModel.titleType, title: viewModel.titleName)
    }

    public  var body: some View {
        GeometryReader { geometry in
            
            TGSVLoading(isShowing: $isLoading) {
                VStack(spacing: 0) {
                    TGSVTitle(viewModel: titleModel)
                        .onBackCallback(action: self.onBackCallback ?? {})
                        .onCloseCallback(action: self.onCloseCallback ?? {})
                    
//                    RefreshableScrollView(onRefresh: { done in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            done()
//                            self.webviewModel.should_refresh.send(true)
//                        }
//                    }) {
                        TGSVWebview(url: self.viewModel.url, viewModel: self.webviewModel)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                    //}
                }
            }
        }
        .onAppear() {
            self.appInfo.currWebCommand  = self.webviewModel
        }
        .onReceive(self.webviewModel.web_command, perform: {webCommand in
            TGSULog.log(TAG, "onReceive web_command : \(webCommand)")
            let cmd  = TGSUCommand.convertWebCommand(webCommand)
            if(cmd != nil) {
                self.viewModel.command.currCommand.send(cmd!)
            }
            
            if(webCommand == "TGSFW_COMD://showProgress"){
                self.isLoading = true
            }
            if(webCommand == "TGSFW_COMD://hideProgress"){
                self.isLoading = false
            }
        })
        .onReceive(self.webviewModel.web_loading, perform: { isLoading in
            self.isLoading = isLoading
        })
        .onReceive(self.webviewModel.web_title, perform: { title in
            self.titleModel.title = title
        })
       
    }
}

//MARK: METHOD
extension TGSVTitleWebview {
    
    // back 버튼 클릭 callback 등록
    func onBackCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onBackCallback = action
        return copy
    }
    // close 버튼 클릭 callback 등록
    func onCloseCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onCloseCallback = action
        return copy
    }
}




struct TGSVTitleWebview_Previews: PreviewProvider {

    static var previews: some View {
        TGSVTitleWebview(TGSVTitleWebviewModel(isShowSelf: .constant(true), command: TGSMCommad(), titleName: "네이버", url: "https://www.naver.com"))
            .environmentObject(TGSAppInfo( isShowSelf: .constant(true)))
    }
}
