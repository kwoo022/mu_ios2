//
//  TGSMQrScanner.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/03.
//

import Foundation

public class TGSMQrScanner: ObservableObject {
    
    public let scanInterval: Double = 1.0
    
    @Published public  var torchIsOn: Bool = false  // 스캔 재시도 빈도 제어
    @Published public  var lastQrCode: String = "Qr-code goes here" // 감지도 QR code
    
    public init(torchIsOn: Bool = false, lastQrCode: String = "Qr-code goes here") {
        self.torchIsOn = torchIsOn
        self.lastQrCode = lastQrCode
    }
    
    public func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
    }
}
