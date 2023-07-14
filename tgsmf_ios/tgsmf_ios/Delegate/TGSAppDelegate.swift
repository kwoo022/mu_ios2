//
//  TGSAppDelegate.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/28.
//

import SwiftUI
import Firebase
import FirebaseMessaging

open class TGSAppDelegate: NSObject, UIApplicationDelegate {
    private let TAG = "[TGSAppDelegate]"
    // 앱이 켜졌을때
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 사용자 폰트 로딩하기
        R.registerCustomFont()
        
        // DB 구축하기
        if TGSMConst.AppUsingFunc.USING_DB {
            TGSUDBPushEntity.shared.createTable()
        }
        
        if( TGSMConst.AppUsingFunc.USING_PUSH ) {
            // Use Firebase library to configure APIs
            // 파이어베이스 설정
            
            FirebaseApp.configure()
                    
            // 원격 알림 등록
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                
                //TGSSidemenuScene에서 알림권한 체크 이후 로직 적용으로 인한 주석처리
                
                /*let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    //completionHandler: { _, _ in }
                    completionHandler: { didAllow, Error in
                        if didAllow{
                            print("Push: 권한허용")
                            
                            /*let param = ["userPushFg" : "Y"]
                            TGSURest.shared.POST(url: TGSMConst.Url.PUSH_FG_SAVE_URL, params: param, isSaveCookies: true,
                                onSuccess: { result in
                                    print("11111111111111")
                                    var jsonObj : Dictionary<String, Any> = [String : Any]()
                                
                                    let userFg = result.result?.userFg!
                                    
                                    TGSUUserDefaults.setIsReceivePush(true)
                                    //TGSUUserDefaults.setRefusePushDate(strPushDate)
                                    
                                
                                    
                                    Messaging.messaging().subscribe(toTopic: "ios_all")
                                    Messaging.messaging().subscribe(toTopic: "ios_"+userFg!)
                                    
                                
                                    
                                },
                                onFail: { result in
                                    print("22222222222222")
                                }
                            )*/
                            
                        }else{
                            print("PUSH: 권한 거부")
                        }
                    }
                )*/
            } else {
                let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            
            application.registerForRemoteNotifications()
            
            // 메세징 델리겟
            Messaging.messaging().delegate = self
            
            
            // 푸시 포그라운드 설정
            UNUserNotificationCenter.current().delegate = self
        }

        return true
    }
    
    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
      ) -> UISceneConfiguration {
          
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        //sceneConfig.delegateClass = TGSSceneDelegate.self
        return sceneConfig
      }

    // fcm 토큰이 등록 되었을 때
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
    
    // 앱이 백그라운드 상태일때 실행되어야 하는데 현재 실행 안됨
    /*public func application(_ application:UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping(UIBackgroundFetchResult) -> Void){
        TGSULog.log(TAG, "background")
        insertPushData(userInfo: userInfo)
        completionHandler(.newData)
    }*/
}

extension TGSAppDelegate : MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let fcm_token_str = fcmToken ?? ""
        TGSUUserDefaults.setFcmToken(fcm_token_str)
        TGSULog.log(TAG, "Firebase token: \(fcm_token_str)")
    }
}

var check = true

extension TGSAppDelegate : UNUserNotificationCenterDelegate {
    
    // 앱이 열린 상태에서 푸시 메시지를 받았을때
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if(TGSUUserDefaults.getIsReceivePush()){
            let userInfo = notification.request.content.userInfo
            insertPushData(userInfo: userInfo)
            check = false
            //앱이 열린 상태에서도 푸시 알림을 표시하고 싶으면 아래 소스 실행
            completionHandler([.banner, .sound, .badge])
        }
    }

    // 앱이 종료 상태이거나 백그라운드 상태에서 푸시메세지를 받았을 때
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if(check){
            insertPushData(userInfo: userInfo)
        }else{
            check = false
        }
    }

    private func insertPushData(userInfo : [AnyHashable : Any]) {
        if !TGSMConst.AppUsingFunc.USING_DB {
            return
        }
            
        let aps = userInfo["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        let title = alert?["title"]
        let body = alert?["body"]
        let url:String = String(describing: userInfo["gcm.notification.url"] ?? "")

        TGSULog.log(TAG, "willPresent: userInfo: ", userInfo)
        TGSULog.log(TAG, "title : ", title ?? "nil")
        TGSULog.log(TAG, "body : ", body ?? "nil")
        TGSULog.log(TAG, "url : ", url)
        
        if(title != nil && body != nil) {
            let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 2020-08-13 16:30
            let strDate = dateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
            
            let push = PushData(id: 0, title: title!, message: body!, insertDt: strDate, isRead: 0, readDt: "", url: url)
            TGSUDBPushEntity.shared.insertData(data: push)
        }
    }

}
