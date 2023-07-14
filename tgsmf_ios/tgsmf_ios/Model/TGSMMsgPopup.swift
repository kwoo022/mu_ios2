//
//  TGSMMsgPopup.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/04.
//

import SwiftUI

public class TGSMMsgPopup: ObservableObject {
    public var title:String?
    public var message:String
    public var messageType :TGS_PopupMsgType
    public var type : TGS_PopupType
    
    
    public init(title: String? = nil, message: String = "", messageType: TGS_PopupMsgType = .nomal, type: TGS_PopupType = .ok) {
        self.title = title
        self.message = message
        self.messageType = messageType
        self.type = type
    }
    
    
}
