import SwiftUI
import tgsmf_ios

// MARK: SideMenu 화면
struct SideMenuScene: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var appInfo : TGSAppInfo
    
    @StateObject var coordinator = NavigationCoordinator()
    // Scene을 구성하는 뷰모델 데이터
    @State private var viewModel : TGSSidemenuSceneModel
    
    
    var tabViewModel : TGSTabviewSceneModel
    var arrTabChildView : [AnyView]
    
    
    // MARK: INITIALIZER
    init(viewModel: TGSSidemenuSceneModel) {
        self.viewModel = viewModel
        // 탭뷰 내부 뷰 객체 리스트
        self.arrTabChildView  = [
            AnyView(TabHome(TGSTabHomeModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, tabIdx: 0, tabIcon: R.Image.foot1, initUrl: TGSMConst.Url.HAKSA_URL))),
            AnyView(TabWeb(TGSTabWebModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, tabIdx: 1, tabIcon: R.Image.foot2, titleType: TGSE_TITLE_TYPE.TITLE, titleName: "게시판", initUrl: TGSMConst.Url.NOTICE_PAGE))),
            AnyView(TGSTabWeb(TGSTabWebModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, tabIdx: 2, tabIcon: R.Image.foot3, titleType: TGSE_TITLE_TYPE.TITLE, titleName: "모바일 신분증", initUrl: TGSMConst.Url.HAKSA_URL+"?AppMenuId=BACH856"))),
            //AnyView(TabHome(TGSTabHomeModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, tabIdx: 2, tabIcon: R.Image.foot3, initUrl: TGSMConst.Url.HAKSA_URL+"?AppMenuId=BACH856"))),
            AnyView(TGSTabSetting(viewModel: TGSTabSettingModel(isShowSelf: viewModel.isShowSelf,command: viewModel.command,  tabIdx: 3, tabIcon: R.Image.foot4)))
        ]
        
        // 탭뷰 모델 객체
        self.tabViewModel = TGSTabviewSceneModel(isShowSelf: viewModel.isShowSelf, command: viewModel.command, initTab: 0, arrTab: self.arrTabChildView)
    }
    
    //MARK: BODY
    var body: some View {
        BaseNavigationView(coordinator: self.coordinator, command: self.viewModel.command) {
            TGSSidemenuScene<TGSTabviewScene>(viewModel: self.viewModel, content:{
                TGSTabviewScene(viewModel: self.tabViewModel)
            })
        }
    }
    
    //MARK: METHOD
    static func initSideMenu() -> [TGSMMenu] {
        let SideSubMenu1 = [
            TGSMMenu(depth: 1, menuName: "학생정보조회", clickEvent : "TGSFW_COMD://webClose?title=학생정보조회&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH024".urlEncoding()),
            TGSMMenu(depth: 1, menuName: "복학신청/휴학연기신청", clickEvent :
                "TGSFW_COMD://webClose?title=복학신청/휴학연기신청&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH030".urlEncoding())
            ]
        let SideSubMenu2 = [
            TGSMMenu(depth: 1, menuName: "전체성적조회", clickEvent : "TGSFW_COMD://webClose?title=전체성적조회&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH342".urlEncoding()),
            TGSMMenu(depth: 1, menuName: "열람성적조회", clickEvent :
                "TGSFW_COMD://webClose?title=열람성적조회&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH742".urlEncoding())
            ]
        let SideSubMenu3 = [
            TGSMMenu(depth: 1, menuName: "개인시간표조회", clickEvent : "TGSFW_COMD://webClose?title=개인시간표조회&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH254".urlEncoding())
            ]
        let SideSubMenu4 = [
            TGSMMenu(depth: 1, menuName: "전체성적조회", clickEvent : "TGSFW_COMD://webClose?title=전체성적조회&url="+"\(TGSMConst.Url.HAKSA_URL)?AppMenuId=BACH728".urlEncoding())
            ]
        let sideMenu = [
            TGSMMenu(depth: 0, menuName: "학적관리", arraySub: SideSubMenu1),
            TGSMMenu(depth: 0, menuName: "성적관리", arraySub: SideSubMenu2),
            TGSMMenu(depth: 0, menuName: "수강관리", arraySub: SideSubMenu3),
            TGSMMenu(depth: 0, menuName: "등록관리", arraySub: SideSubMenu4)
        ]
        
        return sideMenu
        
    }
}

