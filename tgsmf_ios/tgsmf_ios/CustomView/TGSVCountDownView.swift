//
//  TGSVCountDownView.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/02.
//

import SwiftUI

struct TGSVCountDownView: View {
    @ObservedObject var otpModel: TGSMOtp
              
        init(otpModel: TGSMOtp){
            self.otpModel = otpModel
        }
        
        var body: some View {
            Text(otpModel.timeStr)
                //.font(Font.system(size: 15))
                //.foregroundColor(Color.gray)
                //.fontWeight(.semibold)
                .onReceive(otpModel.timer) { _ in
                    otpModel.countDownString()
                }
        }
}

struct TGSVCountDownView_Previews: PreviewProvider {
    static var previews: some View {
        TGSVCountDownView(otpModel: TGSMOtp())
    }
}
