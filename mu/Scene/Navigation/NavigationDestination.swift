import SwiftUI
import tgsmf_ios

//MARK: 앱에서 이동할 수 있는 모든 화면을 정의 한다.
/// 화면에서 화면으로 이동 시 모든 화면으로 NavigationLink 생성의 번거로움을 해소하고자 제공한다.
public  enum NavigationDestination{
    case none
    case launch(TGSLaunchSceneModel)
    case sideMeue(TGSSidemenuSceneModel)
    case titleWebview(TGSWebviewSceneModel)
    case login(TGSLoginSceneModel)
    case push(TGSPushSceneModel)
    case qrScan(TGSQrScanSceneModel)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .none:
            EmptyView()
            
        case .launch(let viewModel):
            LaunchScene(viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        case .sideMeue(let viewModel):
                    SideMenuScene(viewModel: viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        case .titleWebview(let viewModel):
                    WebviewScene(viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        case .login(let viewModel):
                    LoginScene(viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        case .push(let viewModel):
                    PushScene(viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        case .qrScan(let viewModel):
                    QRScanScene(viewModel).environmentObject(TGSAppInfo(isShowSelf: .constant(true))).navigationViewStyle(StackNavigationViewStyle())
        }
    
        
    }
    
}
