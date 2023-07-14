//
//  TGSVPopup.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/30.
//

import SwiftUI


public enum TGS_PopupType {
    case ok
    case okCancel
}
public enum TGS_PopupMsgType {
    case nomal
    case success
    case error
}

public struct TGSVPopup : View {
    let title:String?
    let message:String
    
    @State var arrMessgae:[String]
    
    let messageType :TGS_PopupMsgType
    let type : TGS_PopupType
    
    var okCallback : () -> ()
    var cancelCallback : () -> ()
    
    public init(
        messsage:String,
        title:String? = nil,
        messageType:TGS_PopupMsgType = .nomal,
        type:TGS_PopupType = .ok,
        okCallback: @escaping ()->() = {},
        cancelCallback: @escaping ()->() = {} ){
            self.title = title
            self.message = messsage
            self.arrMessgae  = message.components(separatedBy: "\n")
            
            self.okCallback = okCallback
            self.cancelCallback = cancelCallback
            
            self.messageType = messageType
            self.type = type
        }
    
    private func messageIconImage(_ msgType: TGS_PopupMsgType) -> UIImage {
        switch msgType {
        case .nomal: return R.Image.ic_msg1
        case .success: return  R.Image.ic_ok1
        case .error: return R.Image.ic_no1
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                VStack {
                    
                    TGSVImage( messageIconImage(messageType), contentMode: .fit)
                    .frame(width: 70)
                    Spacer().frame(height: 15)
                    if (self.title != nil) {
                        Text(self.title!)
                            .font(R.Font.font_gmarket_b(size: 17))
                            .foregroundColor(Color(hex: "111111"))
                        Spacer().frame(height: 10)
                    }
                    ForEach(self.arrMessgae, id: \.self) { temp in
                        Text(.init(temp))
                            .font(R.Font.font_noto_r(size: 13))
                            .foregroundColor(Color(hex: "5f6268"))
                    }
//                    Text(.init(self.message))
//                        .font(R.Font.font_noto_r(size: 13))
//                        .foregroundColor(Color(hex: "5f6268"))
                    
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                )
                .cornerRadius(10, corners: [.topLeft, .topRight])
                
                
                
                switch self.type {
                case .ok:
                    Button(action: { self.okCallback() }) {
                        Text("확인")
                            .font(R.Font.font_noto_r(size: 13))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: geometry.size.width, maxHeight: 45)
                    }
                    .frame(maxWidth: geometry.size.width, maxHeight: 45)
                    .background(Color(hex: "4066f6"))
                    .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    
                case .okCancel:
                    HStack(spacing: 0){
                        Button(action: { self.cancelCallback() }) {
                            Text("취소")
                                .font(R.Font.font_noto_r(size: 13))
                                .foregroundColor(Color.white)
                                //.frame(width: .infinity, height: .infinity)
                                .frame(maxWidth: geometry.size.width/2, maxHeight: 45)
                                
                        }
                        .frame(maxWidth: geometry.size.width, maxHeight: 45)
                        .background(Color(hex: "8b9baf"))
                        .cornerRadius(10, corners: [.bottomLeft])
                        
                        Button(action: { self.okCallback() }) {
                            Text("확인")
                                .font(R.Font.font_noto_r(size: 13))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: geometry.size.width/2, maxHeight: 45)
                        }
                        .frame(maxWidth: geometry.size.width/2, maxHeight: 45)
                        .background(Color(hex: "4066f6"))
                        .cornerRadius(10, corners: [.bottomRight])
                    }
                }
            }
            .frame(width: geometry.size.width * 0.8)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 1)
        }
    }
}





struct TGSVPopup_Previews: PreviewProvider {
    static var previews: some View {
        TGSVPopup(messsage: "로그아웃하시겠습니까?", title: "로그아웃", messageType: .nomal, type: .okCancel)
        
        //TGSVPopup(messsage: "메시지입니다.", title: "제목", messageType: .nomal, type: .ok)
        
    }
}
