//
//  TGSMCommand.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/29.
//

import Foundation
import Combine

//TGSMMenu(depth: 1, menuName: "설정", clickEvent : "TGSFW_COMD://moveSetting")
public enum TGSWebCommandType : Int {
    case WCT_MOVE_HOME = 0,
         WCT_MOVE_HOME_RELOAD,
    WCT_MOVE_NOTICE,
    WCT_MOVE_ID_CARD,
    WCT_MOVE_SETTING,
    WCT_MOVE_QR_CHECK,
    WCT_MOVE_PUSH_LIST,
    WCT_MOVE_WEB_CLOSE,
    WCT_MOVE_WEB_BACK,
    WCT_SHOW_DIALOG_MSG,
    WCT_SHOW_DIALOG_MSG_CALLBACK_URL,
    WCT_SHOW_DIALOG_WEB,
    WCT_SHOW_DIALOG_OTP,
    WCT_SHOW_DIALOG_PICTURE_UPLOAD,
    WCT_SHOW_TOAST,
    WCT_ACTION_LOGOUT,
    WCT_MOVE_LOGIN,
    WCT_SHOW_DIALOG_MOVE_LOGIN
}


public struct TGSMComm {
    public var type : Int = 0
    public var param : [String:Any] = [String:Any]()
    
    public init(type: Int = 0, param: [String : Any] = [:]) {
        self.type = type
        self.param = param
    }
}

public class TGSMCommad : ObservableObject {
    
    public var currCommand = PassthroughSubject<TGSMComm, Never>()
    
    public init(currCommand: PassthroughSubject<TGSMComm, Never> = PassthroughSubject<TGSMComm, Never>()) {
        self.currCommand = currCommand
    }
    
//    public var currCommand = CurrentValueSubject<TGSMComm, Never>(TGSMComm())
//
//    public init(currCommand: CurrentValueSubject<TGSMComm, Never> = CurrentValueSubject<TGSMComm, Never>(TGSMComm())) {
//        self.currCommand = currCommand
//    }

}
