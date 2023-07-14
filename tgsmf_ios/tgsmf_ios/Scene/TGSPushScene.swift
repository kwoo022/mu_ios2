//
//  TGSPushScene.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/11.
//

import SwiftUI

// MARK: 푸시 화면뷰모델
public struct TGSPushSceneModel : TGSSceneModel {
    public var isShowSelf: Binding<Bool>
    @ObservedObject  public var command: TGSMCommad
    
    public init(isShowSelf: Binding<Bool>, command: TGSMCommad) {
        self.isShowSelf = isShowSelf
                self.command = command
    }
}

// MARK: 푸시 화면
public struct TGSPushScene: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    @State private var viewModel : TGSPushSceneModel
    //@ObservedObject var command : TGSMCommad = TGSMCommad()
    
    @State var arrPushData:[PushData] = []
    @State var arrExpanded:[Bool] = []
    
    // 전체 메시지 삭제
    @State private var showingDeleteAllPopup : Bool = false
    // 메시지 삭제 결과 팝업
    @State private var showingDeleteResultPopup : Bool = false
    @State private var msgDeleteResult : String = ""
    
    
    // MARK: INITIALIZER
    public init(_ viewModel: TGSPushSceneModel) {
        self.viewModel = viewModel
    }
    
    // MARK: BODY
    public var body: some View {
        GeometryReader { geometry in
            TGSBaseScene(command: self.viewModel.command) {
                VStack(spacing: 0) {
                    TGSVTitle(viewModel: TGSVTitleModel( isShowSelf: self.viewModel.isShowSelf, command: self.viewModel.command, type: .BACK, title: "알람함"))
                        .onBackCallback(action: {
                            self.viewModel.isShowSelf.wrappedValue = false
                            if(self.viewModel.isShowSelf.wrappedValue){
                                let newCmd = "TGSFW_COMD://moveHomeReload"
                                let cmd  = TGSUCommand.convertWebCommand(newCmd)
                                self.viewModel.command.currCommand.send(cmd!)
                            }
                            
                        })
                    HStack {
                        Button(action: {  self.showingDeleteAllPopup = true }) {
                            Text("전체 삭제")
                                .font(R.Font.font_noto_r(size: 10))
                                .frame(maxWidth:50, maxHeight: 25)
                        }
                        .buttonStyle(RoundClickScaleButton(labelColor: R.Color.color_login_button_text,  backgroundColor: R.Color.color_login_button_bg, cornerRadius: 7))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(EdgeInsets(top: 10,leading: 0, bottom: 10, trailing: 10))
                    
                
                    //ScrollView {
                     //   VStack(spacing: 0) {
                            //ForEach(self.arrPushData, id: \.self) { push in
                    List {
                       
                        ForEach(0..<self.arrPushData.count, id: \.self) { index in
                            VStack {
                                HStack {
                                    TGSVImage(R.Image.alarm_ic1).frame(height: 28)

                                    Text(self.arrPushData[index].title)
                                        .font(R.Font.font_noto_m(size: 14))
                                        .foregroundColor(Color.whiteAndBlackColor)
                                    Spacer()
                                    Button(action: { withAnimation{self.arrExpanded[index].toggle()}}) {
                                        TGSVImage((self.arrExpanded[index] ? R.Image.toggle1on_ic1 : R.Image.toggle1_ic1)).frame(height: 14)
                                    }
                                }
                                .frame(height: 58)
                                Divider().foregroundColor(Color(hex: "f3f4f7"))
                            }
                            
                            // 푸시 상세 내용
                            if(self.arrExpanded[index] ) {
                                VStack(alignment: .leading) {
                                    if(self.arrPushData[index].url != ""){
                                        Button(action: {onclick(_url: self.arrPushData[index].url)} ){
                                            Text(self.arrPushData[index].message )
                                                .font(R.Font.font_noto_m(size: 13))
                                                .foregroundColor(Color(hex: "717885"))
                                        }
                                        
                                    }else{
                                        Text(self.arrPushData[index].message )
                                            .font(R.Font.font_noto_m(size: 13))
                                            .foregroundColor(Color(hex: "717885"))
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 20)
                                .background(Color(hex: "f5f6f8"))
                            }
                        }
                        .onDelete(perform: onDelete)
                        .listRowInsets(EdgeInsets.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                        
                    }
                    .listStyle(PlainListStyle())
                    
//                        }
//                    }
//                    .padding(20)
                }
                .frame(height: geometry.size.height, alignment: .topLeading)
                
            }
        }
        .navigationBarHidden(true)
        .popup(isPresented: $showingDeleteAllPopup) {
            TGSVPopup(messsage: "메시지를 전부 삭제하시겠습니까?", title: "알림함", messageType: .nomal, type: .okCancel, okCallback: self.onDeleteAllPushData, cancelCallback: {self.showingDeleteAllPopup=false})
        }
        .popup(isPresented: $showingDeleteResultPopup) {
            TGSVPopup(messsage: self.msgDeleteResult, title: "알림함", messageType: .nomal, type: .ok, okCallback: { self.showingDeleteResultPopup = false } )
        }
        .onAppear() {
            arrPushData = TGSUDBPushEntity.shared.readAllData()
            arrExpanded = [Bool](repeating: true, count: arrPushData.count)
            
            // 푸시화면으로 들어오면 모든 푸시 데이터를 읽음처리 한다.
            TGSUDBPushEntity.shared.updateReaded(id: nil)
            
            self.appInfo.currCommand = self.viewModel.command
        }
    }
    
    // 삭제는 슬라이드 형태로 진행 되므로 팝업을 띄우지 않음
    func onDelete(at offsets: IndexSet) {
        var id = self.arrPushData[offsets.first!].id
        TGSUDBPushEntity.shared.deleteData(id:id)
        self.arrPushData.remove(atOffsets: offsets)
        self.arrExpanded.remove(atOffsets: offsets)
    }
    
    private func onDeleteAllPushData() {
        self.showingDeleteAllPopup = false
        TGSUDBPushEntity.shared.deleteAllData()
        
        // 리스트 정보를 새롭게 갱신한다.
        self.arrPushData = TGSUDBPushEntity.shared.readAllData()
        self.arrExpanded = [Bool](repeating: true, count: arrPushData.count)
        
        self.msgDeleteResult = "메시지가 모두 삭제 되었습니다."
        self.showingDeleteResultPopup = true
    }
    
    private func onclick(_url:String){
        let newCmd = "TGSFW_COMD://webClose?url="+_url
        let cmd  = TGSUCommand.convertWebCommand(newCmd)
        self.viewModel.command.currCommand.send(cmd!)
    }
}

struct TGSPushScene_Previews: PreviewProvider {
    static var previews: some View {
        TGSPushScene(TGSPushSceneModel(isShowSelf: .constant(false), command: TGSMCommad()))
    }
}
