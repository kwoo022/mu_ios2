//
//  TGSMMenu.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/28.
//

import SwiftUI

public struct TGSMMenu {
    public let id : UUID = UUID()
    
    public let depth : Int
    public let menuName : String
    public var clickEvent : String?
    public var arraySub : [TGSMMenu]?
    
    public init(depth: Int, menuName: String, clickEvent: String? = nil, arraySub: [TGSMMenu]? = nil) {
        self.depth = depth
        self.menuName = menuName
        self.clickEvent = clickEvent
        self.arraySub = arraySub
    }
}


extension TGSMMenu : Identifiable {} //identifiable 프로토콜 채택 => List 뷰에서 id를 별도로 설정하지 않아도 됨


/// 사이드 메뉴 테스트 샘플
public let SideSubMenu1 = [
    TGSMMenu(depth: 1, menuName: "홈", clickEvent : "TGSFW_COMD://moveHome"),
    TGSMMenu(depth: 1, menuName: "게시판", clickEvent : "TGSFW_COMD://moveNotice"),
    TGSMMenu(depth: 1, menuName: "모바일신분증", clickEvent : "TGSFW_COMD://moveIdCard"),
    TGSMMenu(depth: 1, menuName: "설정", clickEvent : "TGSFW_COMD://moveSetting")
 ]
public let SideSubMenu2 = [
    TGSMMenu(depth: 1, menuName: "출석체크", clickEvent : "TGSFW_COMD://webClose?title=출석체크&url="+"\(TGSMConst.Url.BASE_URL)/attendanceView".urlEncoding()),
    TGSMMenu(depth: 1, menuName: "현장방문", clickEvent : "TGSFW_COMD://webClose?title=현장방문&url="+"\(TGSMConst.Url.BASE_URL)/checkOutsideView".urlEncoding()),
    TGSMMenu(depth: 1, menuName: "QR출입인증", clickEvent : "TGSFW_COMD://moveQRCheck"),
    TGSMMenu(depth: 1, menuName: "공지사항", clickEvent : "TGSFW_COMD://webBack?title=공지사항&url="+"\(TGSMConst.Url.BASE_URL)/noticeView".urlEncoding())
 ]

public let SideChildMenu3 = [
    TGSMMenu(depth: 2, menuName: "메시지다이얼로그", clickEvent : "TGSFW_COMD://dialog_msg?type=1&title=팝업타이틀&message=팝업메시지입니다."),
    TGSMMenu(depth: 2, menuName: "웹뷰다이얼로그", clickEvent : "TGSFW_COMD://dialog_web?url="+"https://m.naver.com/".urlEncoding()),
    TGSMMenu(depth: 2, menuName: "Otp 다이얼로그", clickEvent : "TGSFW_COMD://dialog_otp?url="+"https://m.naver.com/".urlEncoding()),
    TGSMMenu(depth: 2, menuName: "Picture 다이얼로그", clickEvent : "TGSFW_COMD://dialog_picture_upload?url="+"https://m.naver.com/".urlEncoding()),
    TGSMMenu(depth: 2, menuName: "Toast", clickEvent : "TGSFW_COMD://show_toast?message=Toast 메시지입니다.")
]
public let SideSubMenu3 = [TGSMMenu(depth: 1, menuName: "알림", arraySub: SideChildMenu3)]

public let SideMenuSample = [
    TGSMMenu(depth: 0, menuName: "빠른메뉴", arraySub: SideSubMenu1),
    TGSMMenu(depth: 0, menuName: "학사관리", arraySub: SideSubMenu2),
    TGSMMenu(depth: 0, menuName: "기능테스트", arraySub: SideSubMenu3)
]
