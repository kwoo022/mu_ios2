//
//  TGSUPreview.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/27.
//

import SwiftUI

struct TGSUPreview<V : View>: View {
    enum Device : String, CaseIterable {
        case iPhoneSE = "iPhone SE"
        case iPhone11 = "iPhone 11"
        case iPhone11Pro = "iPhone 11 Pro"
        case iPhone11ProMax = "iPhone 11 Pro Max"
    }
    
    let source : V
    var devices : [Device] = [.iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneSE]
    var displayDarkMode : Bool = true
    
    var body: some View {
        Group {
            ForEach(devices, id:\.self) {
                self.previewSource(device: $0)
            }
            if !devices.isEmpty && displayDarkMode {
                self.previewSource(device: devices[0])
                    .preferredColorScheme(.dark)
            }
        }
    }
    
    
    private func previewSource(device: Device) -> some View{
        source
            .previewDevice(PreviewDevice(rawValue: device.rawValue))
            .previewDisplayName(device.rawValue)
    }
}

struct TGSUPreview_Previews: PreviewProvider {
    static var previews: some View {
        TGSUPreview(source: Text("Hello"))
    }
}
