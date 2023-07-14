//
//  TGSVWebPopup.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/11.
//

import SwiftUI

public class TGSMWebPopup : ObservableObject {
    @Published var url:String = ""
}

public struct TGSVWebPopup: View {
    @Binding var isShowSelf : Bool
    let url:String
    @ObservedObject var webviewModel:TGSMWebviewModel
   
    var okCallback : (String) -> ()
    
    public init(isShow : Binding<Bool>, url: String, webviewModel: TGSMWebviewModel, okCallback: @escaping (String) -> Void) {
        self._isShowSelf = isShow
        self.url = url
        self.webviewModel = webviewModel
        self.okCallback = okCallback
    }
    
    
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                TGSVWebview(url: self.url, viewModel: self.webviewModel)
                    .frame(height: 370)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                
                
                Button(action: { self.isShowSelf = false; self.okCallback(self.url) }) {
                    Text("확인")
                        .font(R.Font.font_noto_r(size: 13))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(Color(hex: "4066f6"))
                //.cornerRadius(10, corners: [.bottomRight])
            }
        }
    }
}

struct TGSVWebPopup_Previews: PreviewProvider {
    static var previews: some View {
        TGSVWebPopup(isShow:.constant(true), url: "http://naver.com", webviewModel: TGSMWebviewModel(), okCallback: { url in })
    }
}
