//
//  TGSVCheckboxStyle.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/27.
//

import SwiftUI

struct TGSVCheckboxStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    let style: Style // custom param

    func makeBody(configuration: Configuration) -> some View {
      Button(action: {
        configuration.isOn.toggle() // toggle the state binding
      }, label: {
        HStack {
          Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
            .imageScale(.large)
          configuration.label
        }
      })
      .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
      .disabled(!isEnabled)
    }

    enum Style {
      case square, circle

      var sfSymbolName: String {
        switch self {
        case .square:
          return "square"
        case .circle:
          return "circle"
        }
      }
    }
  }
