import SwiftUI

//MARK: 한개의 화면을 구성하는 씬 모델 기본 구성
protocol TGSSceneModel {
    var isShowSelf: Binding<Bool> { get set }
    var command : TGSMCommad { get set }
}
