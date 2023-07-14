//
//  TGSMWebviewModel.swift
//  tgsmf_ios
//
//  Webview와 View 사이 간의 구독 시스템 객체
//  - ObservableObject : 구독 시스템 객체
//  - PassthroughSubject : publisher의 일종, 값을 밖으로 내보낼수 있는 기능 포함
//

import SwiftUI
import Foundation
import Combine



// CurrentValueSubject : 값이 변경될 때마다 새 element를 publish (send를 호출하면, 현재 값도 업데이트)
public class TGSMWebviewModel : ObservableObject {
    
    // Webview -> App
    public var web_title = PassthroughSubject<String, Never>()
    public var web_loading = PassthroughSubject<Bool, Never>()
    public var web_command = PassthroughSubject<String, Never>()
    
    // App -> Webview
    public var call_javascript = PassthroughSubject<String, Never>()
    
    public var should_refresh = PassthroughSubject<Bool, Never>()
    public var should_goback = PassthroughSubject<Bool, Never>()
    
    
    
    
    var foo = PassthroughSubject<Bool, Never>()     // AppView에서 WebView로 보내는 값 : View에서 버튼을 눌러서 웹 뷰의 이전 페이지로 이동
    var bar = PassthroughSubject<Bool, Never>()     // WebView에서 AppView로 보내는 값 : 특정 va웹 뷰를 방문한 페이지의 title을 View로 전달하고 싶을때
                                                                        // 웹을 탐색할 때 자체 로딩 애니메이션을 보여주고 싶을때
    
    
}


