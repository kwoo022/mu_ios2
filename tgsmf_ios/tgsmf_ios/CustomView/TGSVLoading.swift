//
//  TGSVLoadingView.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/04.
//

import SwiftUI

struct TGSVLoading<Content>: View where Content: View {
    
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        //GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                
                Color.black
                    .opacity(0.15)
                    .isHidden(!isShowing)
                
                TGSVProgress()
                    .frame(width: 100, height: 50)
                    .position(x:UIScreen.main.bounds.width/2 ,y: UIScreen.main.bounds.height/2-32)
                    .isHidden(!isShowing)
            }
        }
    //}
}

struct TGSVLoading_Previews: PreviewProvider {
    static var previews: some View {
        
        TGSVLoading(isShowing: .constant(true)) {
            Text("TEST")
        }
    }
}
