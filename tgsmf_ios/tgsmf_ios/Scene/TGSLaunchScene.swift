import SwiftUI
import Lottie
// MARK: Launch 화면뷰모델
/// 런처화면 생성 시 모델 데이터를 함께 넘긴다.
public struct TGSLaunchSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    public var command: TGSMCommad
    
    /// 런치 화면이 보여져야 할 시간(초)
    public var showTime : Int = 2

    public init(isShowSelf: Binding<Bool>, command: TGSMCommad, showTime: Int = 2) {
        self.isShowSelf = isShowSelf
        self.command = command
        self.showTime = showTime
    }
    
}

// MARK: Launch 화면
public struct TGSLaunchScene: View{
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    /// Scene을 구성하는 뷰모델 데이터
    var viewModel : TGSLaunchSceneModel

    /// 런치  show Time이 끝난 뒤에 호출되는 함수
    var finishCallback:(()->Void)? = nil
    
    @State private var imageData: Data? = nil
    // MARK: PROPERTIES
    public init(_ viewModel: TGSLaunchSceneModel) {
        self.viewModel = viewModel
    }
    
    
    //MARK: BODY
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                LinearGradient(gradient: Gradient(colors: [Color.white,Color.white]), startPoint: .top,endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                /** 기본 이미지 사용하기 **/
                TGSVImage(R.Image.splash_bg, contentMode: .fit)
                    .frame(width: 150,height: 150)
                    //.animation(.easeOut(duration: 0.5).delay(0.5))
                    .animation(.spring(response: 1,dampingFraction: 0.2,blendDuration: 100))
                    //.animation(.easeIn(duration: 0.5).speed(1))
                    //.transition(.scale.animation(.easeIn(duration:5)))
                /** gif 이미지 사용하기 **/
//                GIFImage(name: "loading2")
//                    .frame(width: 150,height: 150)
//                if let data = imageData {
//                  GIFImage(data: data)
//                        .frame(width: 150,height: 150)
//                } else {
//                  Text("")
//                        .onAppear(perform: loadData)
//                }
            }
        }
        //.frame(width: 550,height: 550)
        .navigationBarHidden(true)
        .onAppear {
            self.appInfo.currIsSelfShow = self.viewModel.isShowSelf
            self.appInfo.currCommand = self.viewModel.command
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(self.viewModel.showTime), repeats: false) { time in
                self.finishCallback?()
            }
        }
    }
    
    
    private func loadData() {
      let task = URLSession.shared.dataTask(with: URL(string: "https://haksa.namhae.ac.kr/common/images/loading2.gif")!) { data, response, error in
        imageData = data
      }
      task.resume()
    }

    //MARK: METHOD
    public func onFinishCallback(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy.finishCallback = action
        return copy
    }
    
    
}

//MARK: PREVIEW
struct TGSLaunchScene_Previews: PreviewProvider {
    static let viewModel = TGSLaunchSceneModel(isShowSelf: .constant(true), command: TGSMCommad(), showTime: 2)
    
    static var previews: some View {
        TGSUPreview(source:  TGSLaunchScene(viewModel)
            .environmentObject(TGSAppInfo(isShowSelf: .constant(true)))
        )
    }
}
