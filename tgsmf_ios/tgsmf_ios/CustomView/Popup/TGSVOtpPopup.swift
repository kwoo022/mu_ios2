

import SwiftUI

//extension Binding where Value == String {
//    func max(_ limit: Int) -> Self {
//        if self.wrappedValue.count > limit {
//            DispatchQueue.main.async {
//                self.wrappedValue = String(self.wrappedValue.dropLast())
//            }
//        }
//        return self
//    }
//}

struct TGSVOtpPopup : View {
    @Binding var isShow : Bool
    @State var otp:[String] =  ["", "", "", ""]

    @ObservedObject var otpModel: TGSMOtp
    
    var okCallback : (String) -> ()
    var closeCallback : () -> ()
    
    init(
        isShow : Binding<Bool>,
        otpModel: TGSMOtp,
        okCallback: @escaping (String)->() = {_ in },
        closeCallback: @escaping ()->() = {} ){
            self._isShow = isShow
            
            self.okCallback = okCallback
            self.closeCallback = closeCallback
            
            self.otpModel = otpModel
        }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading){
                        Text("OTP 인증 번호")
                            .font(R.Font.font_gmarket_b(size: 17))
                            .foregroundColor(Color(hex: "111111"))
                        Spacer().frame(height: 10)
                        Text("OTP 인증번호 4자리를 입력해주세요.")
                            .font(R.Font.font_noto_r(size: 13))
                            .foregroundColor(Color(hex: "5f6268"))
                        Spacer().frame(height: 15)
                        
                        TGSVOTPTextFieldView(otpModel: self.otpModel)
                        
                        HStack(alignment: .bottom, spacing: 0){
                            Spacer()
                            TGSVImage(R.Image.gnb_close1, contentMode: .fit)
                                .frame(width: 14)
                            Spacer().frame(width: 5)
                            Text("유효시간 :").foregroundColor(Color(hex: "5f6268"))
                            TGSVCountDownView(otpModel: self.otpModel).foregroundColor(Color(hex: "ed5554"))
                            Text("초").foregroundColor(Color(hex: "5f6268"))
                        }
                        .font(R.Font.font_noto_r(size: 13))
                        .padding(.top, 13)
                        .padding(.bottom, 23)
                        //.background(Color.yellow)
                        
                        Button(action: {  self.callbackOk() }) {
                            Text("확인")
                                .font(R.Font.font_noto_r(size: 13))
                                .frame(maxWidth: .infinity, maxHeight: 45)
                        }
                        .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: Color(hex: "4066f6"), cornerRadius: 10))
                        .padding(.top, 32)
                        //.disabled(!phoneViewModel.timerExpired)
                    }
                    .frame(maxWidth: .infinity)
                    
                    
                    
                    
                    Button(action: {self.callbackCancel()}) {
                        TGSVImage(R.Image.gnb_close1)
                            .frame(width: 17)
                    }
                    
                }
                .padding(30)
                .frame(width: geometry.size.width)
                .background(
                    Color.white
                )
                .cornerRadius(10, corners: [.topLeft, .topRight])
                //.padding(30)
            }
        }
        
        
    }
    
    
    func callbackOk() {
        self.otpModel.stopTimer()
        self.isShow = false
        self.okCallback(self.otpModel.otp)
    }
    
    func callbackCancel() {
        self.otpModel.stopTimer()
        self.isShow = false
        self.closeCallback()
    }
    
}

struct TGSVOtpPopup_Previews: PreviewProvider {
    static var previews: some View {
        TGSVOtpPopup(isShow: .constant(true), otpModel: TGSMOtp())
       
        
    }
}
