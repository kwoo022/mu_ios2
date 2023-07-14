import SwiftUI
import tgsmf_ios

struct WebviewScene: View {
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSWebviewSceneModel
    @StateObject var coordinator = NavigationCoordinator()
    
    // MARK: INITIALIZER
    init(_ viewModel: TGSWebviewSceneModel) {
        self.viewModel = viewModel
    }
    
    //MARK: BODY
    var body: some View {
        BaseNavigationView(coordinator: self.coordinator, command: self.viewModel.command) {
            TGSWebviewScene(viewModel)
                .onOtpPopupCallback(action: {otp in
                    let str = "javascript:requestAttend( \(otp) )"
                    self.appInfo.currWebCommand.call_javascript.send(str)
                })
                .onPicturePopupCallback(action: {arrPicture, lat, lot in
                    
                    //서버에 현장체크 데이터를 업로드 진행 후 결과에 따라 웹화면에 전달한다.
                    var arrImg = [UIImage]()
                    for img in arrPicture {
                        arrImg.append(img.image)
                    }
                    requestOutsideCheck(images: arrImg, lat: lat, lot: lot)
                })
        }
    }
    
    // 현장 등록 처리를 진행한다.
    func requestOutsideCheck(images:[UIImage], lat:Double, lot:Double) {
        self.appInfo.showLoading = true
        
        TGSURest.shared.UPLOAD(url: TGSMConst.Url.ATTEND_OUTSIDE, params: ["lat":lat.description, "lot":lot.description],  images: images,
                               onSuccess: { result in
            self.appInfo.showLoading = false
            // 웹페이지로 현장방문체크 성공상태를 전송한다.
            let str = "javascript:requestAttend()"
            self.appInfo.currWebCommand.call_javascript.send(str)
        },
                               onFail: {result in
            self.appInfo.showLoading = false
            // 현장방문체크 실패 메시지를 출력한다.
            self.viewModel.command.currCommand.send(TGSMComm(type: TGSWebCommandType.WCT_SHOW_DIALOG_MSG.rawValue, param: ["type" : "error", "title":"현장 방문 등록", "message":result.message]))
        })
    }
}

struct WebviewScene_Previews: PreviewProvider {
    static var previews: some View {
        WebviewScene(TGSWebviewSceneModel(isShowSelf: .constant(true), command: TGSMCommad(), titleName: "타이틀", url: "http://www.naver.com"))
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
        
    }
}
