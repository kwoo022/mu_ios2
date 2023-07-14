//
//  TGSVOTPTextFieldView.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/02.
//

import SwiftUI
import Combine


public struct TGSVOTPTextFieldView: View {
    enum FocusField: Hashable {
        case field
    }
    @ObservedObject var otpModel: TGSMOtp
    // ios15이상
    //@FocusState private var focusedField: FocusField?
    @State private var isFocusedField: Bool = true
    
   public init(otpModel: TGSMOtp){
        self.otpModel = otpModel
        
        UITextField.appearance().clearButtonMode = .never
        UITextField.appearance().tintColor = UIColor.clear
    }
    
    public var backgroundTextField: some View {
        return  TGSVTextField(text: $otpModel.otp, placeholder: "", isFirstResponder: true, isFocused: $isFocusedField)
            .frame(width: 0, height: 0, alignment: .center)
            .font(Font.system(size: 0))
            .accentColor(.blue)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(otpModel.otp)) { _ in otpModel.limitText(TGSMConst.Otp.OTP_CODE_LENGTH) }
            .padding()
            .opacity(0)
    }
    
    public var body: some View {
        HStack(){
            
            ZStack(alignment: .center) {
                backgroundTextField
                
                HStack {
                    Spacer()
                    ForEach(0..<TGSMConst.Otp.OTP_CODE_LENGTH) { index in
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "edebeb"), lineWidth: 1)
                                .frame(width: 45, height: 45)
                                .background(Color.white.cornerRadius(10))
                            Text(otpModel.getOtp(at: index))
                                .font(R.Font.font_gmarket_b(size: 24))
                                .foregroundColor(Color(hex: "33b384"))
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "f5f6f8"))
        .cornerRadius(10)
        
    }
}

//@available(iOS 15.0, *)
struct TGSVOTPTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TGSVOTPTextFieldView(otpModel: TGSMOtp())
    }
}
