//
//  TGSUCommand.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/04.
//

import SwiftUI

class TGSUCommand {
    static let shared = TGSUCommand()
   static let cmd = shared.command
    
    @ObservedObject var command:TGSMCommad = TGSMCommad()
    private var rootCommand = "TGSFW_COMD://"
    private var webCommand = [Int:String]()


    private init() {
        addCommand(key: TGSWebCommandType.WCT_MOVE_HOME.rawValue, command: "\(rootCommand)moveHome")
        addCommand(key: TGSWebCommandType.WCT_MOVE_HOME_RELOAD.rawValue, command: "\(rootCommand)moveHomeReload")
        addCommand(key: TGSWebCommandType.WCT_MOVE_NOTICE.rawValue, command: "\(rootCommand)moveNotice")
        addCommand(key: TGSWebCommandType.WCT_MOVE_ID_CARD.rawValue, command: "\(rootCommand)moveIdCard")
        addCommand(key: TGSWebCommandType.WCT_MOVE_SETTING.rawValue, command: "\(rootCommand)moveSetting")
        addCommand(key: TGSWebCommandType.WCT_MOVE_QR_CHECK.rawValue, command: "\(rootCommand)moveQRCheck")
        addCommand(key: TGSWebCommandType.WCT_MOVE_WEB_CLOSE.rawValue, command: "\(rootCommand)webClose")
        addCommand(key: TGSWebCommandType.WCT_MOVE_WEB_BACK.rawValue, command: "\(rootCommand)webBack")
        addCommand(key: TGSWebCommandType.WCT_SHOW_DIALOG_MSG.rawValue, command: "\(rootCommand)dialog_msg")
        addCommand(key: TGSWebCommandType.WCT_SHOW_DIALOG_WEB.rawValue, command: "\(rootCommand)dialog_web")
        addCommand(key: TGSWebCommandType.WCT_SHOW_DIALOG_OTP.rawValue, command: "\(rootCommand)dialog_otp")
        addCommand(key: TGSWebCommandType.WCT_SHOW_DIALOG_PICTURE_UPLOAD.rawValue, command: "\(rootCommand)dialog_picture_upload")
        addCommand(key: TGSWebCommandType.WCT_SHOW_TOAST.rawValue, command: "\(rootCommand)show_toast")
        addCommand(key: TGSWebCommandType.WCT_MOVE_LOGIN.rawValue, command: "\(rootCommand)moveLogin")
        addCommand(key: TGSWebCommandType.WCT_SHOW_DIALOG_MOVE_LOGIN.rawValue, command: "\(rootCommand)dialog_moveLogin")
        addCommand(key: TGSWebCommandType.WCT_ACTION_LOGOUT.rawValue, command: "\(rootCommand)moveLogout")
    }
    
    func addCommand(key:Int, command:String) {
        if self.webCommand[key] == nil  {
            self.webCommand[key] = command
        }
    }
    
    
    //-----------------------------------------------------------------
    // 웹 커맨드 문자열을 커맨드객체로 변경
    static func convertWebCommand(_ strUrl:String) -> TGSMComm? {
        guard var type = convertWebCommandType(strUrl) else {
            return nil
        }
        
        var comm = TGSMComm(type: type, param: convertWebCommandParam(strUrl))
        return comm
    }
    
    //-----------------------------------------------------------------
    // 웹 커맨드 문자열을 타입으로 변경
    static func convertWebCommandType(_ strUrl:String) -> Int? {
        var command = strUrl
        let arrParse = strUrl.split(separator: "?")
        if(arrParse.count > 1) {
            command = String(arrParse[0])
        }
        
        for (key, cmd) in TGSUCommand.shared.webCommand {
            if(cmd == command) {
                return key
            }
        }
           
        return nil
    }
    
    //-----------------------------------------------------------------
    // TGSFW_COMD://command?key=test&page=1
    // 커스텀커맨드에 전달된 인자를 딕셔너리 형태로 리턴한다.
    static func convertWebCommandParam(_ strUrl:String) -> [String:String] {
        var mapParams = [String:String]()
        
        let arrSeparated = strUrl.split(separator: "?")
        if(arrSeparated.count > 1) {
            arrSeparated[1].split(separator: "&").map { param in
                let keyvalue = param.split(separator: "=")
                if(keyvalue.count >= 2) {
                    let key : String = String(keyvalue[0]).urlDecoding()
                    let value : String = String(keyvalue[1]).urlDecoding()
                    
                    mapParams[key] = value
                }
            }
        }
        
        return mapParams
    }
}


