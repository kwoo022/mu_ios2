//
//  TGSMConst.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/28.
//

import Foundation


public class TGSMConst {
    public class AppUsingFunc {
        public static var USING_PUSH = true
        public static var USING_DB = true
    }
    
    public class Url {

        public static var BASE_URL =   "https://haksa.namhae.ac.kr"
        //public static var BASE_URL =   "http://192.168.21.96:8080"
        //static let MAIN_PAGE = "https://www.naver.com"
        public static var MAIN_PAGE = "\(BASE_URL)/mainView"
        public static var NOTICE_PAGE = "https://univ.namhae.ac.kr/namhae_01/web/cop/bbs/selectBoardList.do?pageIndex=1&searchCnd=0&searchWrd=&bbsId=BBSMSTR_000000000284&nttId=20804"
        public static var ID_CARD_PAGE = "\(BASE_URL)/idCardView"
        
        public static var LOGIN = "\(BASE_URL)/app/postLogin"               // Post, param = id, password
        public static var LOGOUT = "\(BASE_URL)/app/ios/logout"
        public static var QR_CHECKIN = "\(BASE_URL)/qrCheckIn"              // GET, param = qrcode
        public static var ATTEND_OUTSIDE = "\(BASE_URL)/checkOutside"       // Post, param = images
        public static var HAKSA_URL = BASE_URL+"/app/main"
        public static var PUSH_FG_SAVE_URL = BASE_URL+"/app/postPushFgSave"
    }
   
    public class Webview {
        public static var webBridgeName = "TGSFW"
    }
    
    public class Otp {
        public static let OTP_CODE_LENGTH = 4
        public static let COUNTDOWN_TIMER_LENGTH = 5
    }
    
    public class DB {
        public static let DATABASENAME = "tgsData.sqlite"
        public static let DB_TABLENAME_PUSH = "TB_PUSH_MESSAGE"
    }

}
