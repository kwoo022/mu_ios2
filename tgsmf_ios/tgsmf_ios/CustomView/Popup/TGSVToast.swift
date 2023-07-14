//
//  TGSVToast.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/11.
//

import SwiftUI

public class TGSMToast : ObservableObject {
    @Published var message:String = ""
}


public struct TGSVToast: View {
    
    @State var message : String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack(alignment: .center,spacing: 10){
            Image(systemName: "paperplane.fill")
                .font(.system(size: 25))
                .padding(.leading, 5)
                .foregroundColor(Color.white)
            VStack(alignment: .leading, spacing: 2){
                Text(message)
                    .fontWeight(.black)
                    .foregroundColor(Color.white)
            }
            .padding(.trailing, 15)
            //                    .background(Color.red)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(R.Color.color_login_button_bg)
        .cornerRadius(25)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 30)
        
    }
}

struct TGSVToast_Previews: PreviewProvider {
    static var previews: some View {
        TGSVToast(message: "메시지 입니다.")
    }
}
