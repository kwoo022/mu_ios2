//
//  TGSUUserDefaults.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/30.
//

import Foundation

// 앱 설정 정보를 관리한다.
// 싱글톤 객체로 생성.
public class TGSUUserDefaults {
    //static let inst = TGSUUserDefaults()
   
    
    static let KEY_IS_RECEIVE_PUSH = "isReceivePush"
    static let KEY_REFUSE_PUSH_DATE = "refusePushDate"
    static let KEY_IS_SAVE_ACCOUNT = "isSaveAccount"
    static let KEY_SAVE_LOGIN_ID = "saveLoginId"
    static let KEY_SAVE_LOGIN_PW = "saveLoginPw"
    static let KEY_IS_SAVE_LOGOUT = "isSaveLogout"
    
    static let KEY_FCM_TOKEN = "fcm_token"
    static let KEY_WEB_APP_TOKEN = "app_token"
    
    static let KEY_IS_USER_PUSH_FG = "userPushFg"
    
    static let KEY_FIRST_LOGIN = "firstLogin"
    
    
    //private let userDefaults:UserDefaults
    
//    private init() {
//        self.userDefaults = UserDefaults.standard
//        self.userDefaults.register(
//            defaults: [
//                "isReceivePush": true,
//                "refusePushDate":"",
//                "isSaveAccount": true,
//                "saveLoginId":"",
//                "saveLoginPw":""
//            ]
//        )
//
//    }
    
    public static func setIsReceivePush(_ value: Bool) { UserDefaults.standard.set(value, forKey: TGSUUserDefaults.KEY_IS_RECEIVE_PUSH) }
    public static func getIsReceivePush() -> Bool { return UserDefaults.standard.bool(forKey: TGSUUserDefaults.KEY_IS_RECEIVE_PUSH) }
    
    public static func setRefusePushDate(_ value: String) { UserDefaults.standard.set(value, forKey: TGSUUserDefaults.KEY_REFUSE_PUSH_DATE) }
    public static func getRefusePushDate() -> String {
        return (UserDefaults.standard.string(forKey: TGSUUserDefaults.KEY_REFUSE_PUSH_DATE) ?? "")
    }
    
    public static func setIsSaveAccount(_ value: Bool) {UserDefaults.standard.set(value, forKey: KEY_IS_SAVE_ACCOUNT) }
    public static func getIsSaveAccount() -> Bool { return UserDefaults.standard.bool(forKey: KEY_IS_SAVE_ACCOUNT) }
    
    public static func setLoginId(_ value: String) { UserDefaults.standard.set(value, forKey: KEY_SAVE_LOGIN_ID) }
    public static func getLoginId() -> String {
        return UserDefaults.standard.string(forKey: KEY_SAVE_LOGIN_ID) ?? ""
    }
    
    public static func setLoginPw(_ value: String) { UserDefaults.standard.set(value, forKey: KEY_SAVE_LOGIN_PW) }
    public static func getLoginPw() -> String {
        return UserDefaults.standard.string(forKey: KEY_SAVE_LOGIN_PW) ?? ""
    }
    
    public static func setIsSaveLogout(_ value: String) {UserDefaults.standard.set(value, forKey: KEY_IS_SAVE_LOGOUT) }
    public static func getIsSaveLogout() -> String { return UserDefaults.standard.string(forKey: KEY_IS_SAVE_LOGOUT) ?? ""}
    
    public static func setFcmToken(_ value: String) {UserDefaults.standard.set(value, forKey: KEY_FCM_TOKEN) }
    public static func getFcmToken() -> String { return UserDefaults.standard.string(forKey: KEY_FCM_TOKEN) ?? ""}
    
    public static func setWebAppToken(_ value: String) {UserDefaults.standard.set(value, forKey: KEY_WEB_APP_TOKEN) }
    public static func getWebAppToken() -> String { return UserDefaults.standard.string(forKey: KEY_WEB_APP_TOKEN) ?? ""}
    
    public static func setUserPushFg(_ value:String) {UserDefaults.standard.set(value, forKey: KEY_IS_USER_PUSH_FG)}
    public static func getUserPushFg() -> String { return UserDefaults.standard.string(forKey: KEY_IS_USER_PUSH_FG) ?? ""}
    
    public static func setFirstLogin(_ value:Bool) {UserDefaults.standard.set(value, forKey: KEY_FIRST_LOGIN) }
    public static func getFirstLogin() -> Bool { return UserDefaults.standard.bool(forKey: KEY_FIRST_LOGIN) }
}
