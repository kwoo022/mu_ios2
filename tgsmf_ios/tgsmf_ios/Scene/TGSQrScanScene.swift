
import SwiftUI


// MARK: QrScan 화면뷰모델
public struct TGSQrScanSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    @ObservedObject var qrScan:TGSMQrScanner
    
    var backCallback:(()->Void)
    var scanCallback:((_ qrCode:String)->Void)
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, qrScan :TGSMQrScanner,
                scanCallback : @escaping (String) -> Void = {qrcode in},
                backCallback : @escaping () -> Void = {}) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.qrScan = qrScan
        self.backCallback = backCallback
        self.scanCallback = scanCallback
    }
}
    
// MARK: QrScan 화면
public struct TGSQrScanScene: View {
    private let TAG = "[TGSQrScanScene]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSQrScanSceneModel
    
    @State var titleModel : TGSVTitleModel
    
    //@ObservedObject var viewModel:TGSMQrScanner
    //@Binding var isSelfShow : Bool
    //@StateObject var command = TGSMCommad()
    
//    var backCallback:(()->Void)? = nil
//    var scanCallback:((_ qrCode:String)->Void)? = nil
    
    // MARK: INITIALIZER
    public init(_ viewModel : TGSQrScanSceneModel) {
        self.viewModel = viewModel
        
        self.titleModel = TGSVTitleModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, type: .BACK, title: "QR 스캔")
    }
    
    //MARK: BODY
    public var body: some View {
        VStack(spacing: 0) {
            TGSVTitle(viewModel: titleModel)
                .onBackCallback(action: self.onBackCallback)
            ZStack {
                TGSUQrCodeScannerView()
                    .found(r: self.onScanQrcode(_:))
                    .torchLight(isOn: self.viewModel.qrScan.torchIsOn)
                    .interval(delay: self.viewModel.qrScan.scanInterval)
                
                TGSVImage(R.Image.ic_lens1)
                    .padding(50)
            }
            VStack(alignment: .center){
                Text("입장을 위한 QR 스캔")
                    .font(R.Font.font_gmarket_b(size: 17))
                    .foregroundColor(Color(hex: "111111"))
                Text("입장하는 건물의 QR코드를 인식하세요.")
                    .padding(.top, 10)
                    .font(R.Font.font_noto_r(size: 13))
                    .foregroundColor(Color(hex: "5f6268"))
            }
            .frame(height: 120)
            .background(Color.white)
        }
        
    }
    
    
    //MARK: METHOD
    /// back 버튼 콜백 등록
//    public func onBackCallback ( action: @escaping () -> Void) -> Self {
//        var copy  = self
//        copy.backCallback = action
//        return copy
//    }
//
//    // 스캔 완료 콜백 등록
//    public func onScanCallback ( action: @escaping (String) -> Void) -> Self {
//        var copy  = self
//        copy.scanCallback = action
//        return copy
//    }
    
    // Back 버튼을 눌렀을때
    func onBackCallback() {
        self.viewModel.backCallback()
        self.viewModel.isShowSelf.wrappedValue = false
    }
        
    // Scan 버튼을 눌렀을때
    func onScanQrcode(_ qrCode: String) {
        TGSULog.log(TAG, "onScanQrcode : \(qrCode)")
        //self.viewModel.scanCallback(qrCode)
        //self.viewModel.isShowSelf.wrappedValue = false
        let newCmd = "TGSFW_COMD://webClose?url="+qrCode
        let cmd  = TGSUCommand.convertWebCommand(newCmd)
        self.viewModel.command.currCommand.send(cmd!)
        
    }
}

struct TGSQrScanScene_Previews: PreviewProvider {
    static var previews: some View {
        TGSQrScanScene(TGSQrScanSceneModel(isShowSelf: .constant(true), command: TGSMCommad(), qrScan: TGSMQrScanner()))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
    }
}
