import SwiftUI
import tgsmf_ios

// MARK: Launch 화면
struct TabHome: View {
    let TAG = "[TabHome]"
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSTabHomeModel
    
    // MARK: INITIALIZER
    init(_ viewModel: TGSTabHomeModel) {
        self.viewModel = viewModel
    }
    
    //MARK: BODY
    var body: some View {
        TGSTabHome(self.viewModel)
    }
    
    //MARK: METHOD
}
