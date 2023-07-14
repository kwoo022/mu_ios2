//
//  TGSVButton.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/27.
//

import SwiftUI

struct ClickScaleButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.94 : 1.0) // <-
  }
}


struct RoundClickScaleButton: ButtonStyle {
    var labelColor = Color.white
    var backgroundColor = Color.blue
    var cornerRadius : CGFloat = 0
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .foregroundColor(labelColor)
      .background(
        RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor)
              //.stroke(.black, lineWidth: 2)
             //.background(backgroundColor.cornerRadius(10))
      )
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0) // <-
  }
}
