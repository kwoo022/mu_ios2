//
// ios 15 이하버전에서는 TextField에 Focus를 관리할 수 있는 기능이 없어
// 유사하게 기능 구현
//

import SwiftUI

public struct TGSVTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isFirstResponder: Bool = false
    @Binding var isFocused: Bool
    
    public func makeUIView(context: UIViewRepresentableContext<TGSVTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<TGSVTextField>) {
        uiView.text = self.text
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
    }
    
    public func makeCoordinator() -> TGSVTextField.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var didFirstResponder = false
        
        public init(text: Binding<String>, isFocused: Binding<Bool>) {
            self._text = text
            self._isFocused = isFocused
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFocused = true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFocused = false
        }
    }
}
