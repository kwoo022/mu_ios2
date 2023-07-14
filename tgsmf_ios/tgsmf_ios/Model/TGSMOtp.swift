//
//  TGSMOtp.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/03.
//

import SwiftUI



public class TGSMOtp: ObservableObject {
    
    public var limitTime :Int = 0

    @Published var otp:String = ""
    @Published var timerExpired = false
    @Published var timeStr = ""
    @Published var timeRemaining = 120
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    //MARK: init
    public init() {
        limitTime = 0
    }
    
    public init(_ limitTime:Int) {
        self.limitTime = limitTime
    }
    
    
    //MARK: Timer
    public func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
    public func startTimer() {
        timeRemaining = limitTime
        timerExpired = false
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        //Start new round of verification
        self.otp = ""
    }

    public func countDownString() {
        guard (timeRemaining > 0) else {
            self.timer.upstream.connect().cancel()
            timerExpired = true
            timeStr = String(format: "%d", 00)
            return
        }
        
        timeRemaining -= 1
        timeStr = String(format: "%d", timeRemaining)
    }
    
    //MARK: Otp
    public func getOtp(at index: Int) -> String {
        guard self.otp.count > index else {
            return ""
        }
        return self.otp[index]
    }
    
    public func limitText(_ upper: Int) {
        if otp.count > upper {
            otp = String(otp.prefix(upper))
        }
    }
    
}

