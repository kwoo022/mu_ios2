//
//  TGSExtension.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/02.
//

import SwiftUI
import Combine


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
        
    }
}

extension View {
    //--------------------------------------------------------------------------
    // view 숨김 처리
    @ViewBuilder func isHidden(_ hidden:Bool, remove:Bool = false)->some View {
        if hidden {
            if !remove{
                self.hidden()
            }
        } else {
            self
        }
    }
    //--------------------------------------------------------------------------
    // value 값 변경을 감지하고 싶을때 사용
    // onChange(of:perform:) 를 사용하려고 했으나 onChange는 iOS 14부터 지원
    // [사용법]
    // @State private var selectedFlavor = ""
    // View.valueChanged(value: selectedFlavor, onChange: { value in print(value) })
    @ViewBuilder func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
    
    
    
    
    
    //--------------------------------------------------------------------------
    // view 라운딩 처리
    // .cornerRadius(20, corners: [.topLeft, .bottomRight])
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    //--------------------------------------------------------------------------
    // view 라운딩 (fill + stroke)
    // Color.white.borderRadius(Color.yellow, width: 1, radius: 10, corners: [.topLeft, .bottomLeft])
    public func borderRadius<S>(_ content: S, width: CGFloat = 1, radius: CGFloat, corners: UIRectCorner) -> some View where S : ShapeStyle {
        let roundedRect = RoundedCorner(radius: radius, corners: corners)
        return clipShape(roundedRect)
            .overlay(roundedRect.stroke(content, lineWidth: width))
    }
}


//MARK: Binding
public extension Binding {
    //--------------------------------------------------------------------------
    /// 바인딩 객체 값이 변경 되었을때 handler가 호출됨
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> where Value: Equatable {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if self.wrappedValue != newValue { // equal check
                    self.wrappedValue = newValue
                    handler(newValue)
                }
            }
        )
    }
}

extension String {
    public subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
    
    public func urlEncoding() -> String {
        self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!@#$%^&*(){}[]?<>/=").inverted/*.urlHostAllowed*/)!
        //self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    public func urlDecoding() -> String{
        self.removingPercentEncoding ?? self
    }
    
   static let SECRET_KEY:String = "tgsmf"
    static let IV = "0123456789012345"
    
    // 암호화
    func sha256_encryped() -> String{
        return self
    }
    // 복호화
    func sha256_decryped() -> String{
        return self
    }

}
