//
//  TGSVTitle.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/30.
//

import SwiftUI

// MARK: 상단 타이들바 타입
public enum TGSE_TITLE_TYPE {
    case NONE, TITLE, BACK, CLOSE, BACK_CLOSE
}


// MARK: 상단 타이들바 뷰 모델
public struct TGSVTitleModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    var type : TGSE_TITLE_TYPE
    var title : String
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad,  type: TGSE_TITLE_TYPE = TGSE_TITLE_TYPE.BACK_CLOSE, title: String = "") {
        self.isShowSelf = isShowSelf
        self.command = command
        self.type = type
        self.title = title
    }
}



// MARK: 상단 타이들바 뷰 모델
public struct TGSVTitle : View {

    // MARK: PROPERTIES
    @State private var viewModel : TGSVTitleModel
    
    var onBackCallback:(()->Void)? = nil
    var onCloseCallback:(()->Void)? = nil

    var web_title : String
    // MARK: INITIALIZER
    public init(viewModel: TGSVTitleModel) {
        self.viewModel = viewModel
        self.web_title = viewModel.title
    }

    
    // MARK: BODY
    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack {
                Button(action: { self.onBackButton() }) {
                    TGSVImage(R.Image.head_prev_ic1, contentMode: .fit)
                        .frame(maxHeight: .infinity)
                }
                .padding(10)
                .isHidden( (self.viewModel.type == TGSE_TITLE_TYPE.BACK || self.viewModel.type == TGSE_TITLE_TYPE.BACK_CLOSE) ? false : true)
                
                Spacer()
                Text(self.reTitle())
                    .font(R.Font.font_noto_b(size: 16))
                    .foregroundColor(Color.whiteAndBlackColor)
                    .isHidden( (self.viewModel.type == TGSE_TITLE_TYPE.NONE) ? true : false)
                Spacer()
                
                Button(action: { self.onCloseButton() }) {
                    TGSVImage(R.Image.head_close_ic1, contentMode: .fit)
                        .frame(maxHeight: .infinity)
                }
                .isHidden( (self.viewModel.type == TGSE_TITLE_TYPE.CLOSE || self.viewModel.type == TGSE_TITLE_TYPE.BACK_CLOSE) ? false : true)
                .padding(12)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            Divider()
        }
        .frame(height: self.viewModel.type==TGSE_TITLE_TYPE.NONE ? 0 : 50)
        .background(Color.whiteAndBlackBgColor)
        //.edgesIgnoringSafeArea(.top)
    }
}

// MARK: METHOD
extension TGSVTitle {
    // Back버튼을 눌렀을때
    func onBackButton() {
        if(self.onBackCallback != nil) {
            self.onBackCallback!()
        } else {
            self.viewModel.isShowSelf.wrappedValue = false
        }
    }
    //Close 버튼을 눌렀을때
    func onCloseButton() {
        if(self.onCloseCallback != nil) {
            self.onCloseCallback!()
        }  else {
            self.viewModel.isShowSelf.wrappedValue = false
        }
    }
    
    func onBackCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onBackCallback = action
        return copy
    }
    
    func onCloseCallback ( action: @escaping () -> Void) -> Self {
        var copy  = self
        copy.onCloseCallback = action
        return copy
    }

    func reTitle()  -> String{
        var reTitle = self.viewModel.title
        if(self.viewModel.title == ""){
            reTitle = self.web_title
        }
        return reTitle
    }
    
    
}



struct TGSVTitle_Previews: PreviewProvider {
    static var previews: some View {
        TGSVTitle(viewModel: TGSVTitleModel(isShowSelf: .constant(true), command: TGSMCommad(), title: "타이틀"))
    }
}
