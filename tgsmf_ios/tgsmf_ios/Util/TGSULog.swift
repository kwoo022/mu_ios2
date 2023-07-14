//
//  TGSULog.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/05.
//

import SwiftUI

class TGSULog {
    static var WRITE_LOG:Bool = true
    static var TAG:String = "TGS"
    
  
    
    static func log(_ items: Any..., tag:String = TAG) {
        if WRITE_LOG {
            print("[\(tag)] ", items)
        }
    }
    
//    public func NSLog(_ format: String, _ args: CVarArg...) {
//        #if DEBUG
//        Foundation.NSLog(String(format: format, arguments: args))
//        #endif
//    }
   
}
