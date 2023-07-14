//
//  TGSVWebview.swift
//  tgsmf_ios
//
//  웹 페이지를 화면에 보여주는 View
//

import SwiftUI
import Combine
import WebKit

// Javascript와 Native 간의 데이터 전송
// 주고받을 형식에 대한 프로토콜 생성
protocol TGSPWebViewHandlerDelegate {
    func receivedCommandFromWebView(value: String)
    //func receivedStringValueFromWebView(value: String)
}

public struct TGSVWebview : UIViewRepresentable, TGSPWebViewHandlerDelegate {
    let TAG = "TGSVWebview"
    
    // MARK: PROPERTIES
    public static var COOKIES_HEADER = "appToken"
    
    var url : String
    @ObservedObject var viewModel:TGSMWebviewModel
    
    public static var beforeUrl = ""
    public init(url: String, viewModel: TGSMWebviewModel) {
        self.url = url
        self.viewModel = viewModel
    }
  
    
    // 변경 사항을 전달하는 데 사용하는 사용자 지정 인스턴스를 만든다
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 뷰 객체를 생성하고 초기 상태를 구성한다.
    public func makeUIView(context: Context) -> WKWebView {
        guard let url  = URL(string: self.url) else {
            return WKWebView()
        }
        
        
        //WKPreferences : 웹 사이트에 적용 할 표준 동작을 캡슐화하는 개체
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false // JavaScript가 사용자 상호 작용없이 창을 열 수 있는지 여부
        
        // WKWebViewConfiguration : 웹보기를 초기화하는 데 사용하는 속성 모음
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        // Cookies 동기화 (http api로 로그인을 실행했을 경우 쿠키를 동기화 시킨다.)
        for cookie in TGSURest.COOKIES {
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
        configuration.userContentController.add(self.makeCoordinator(),
                                                name: TGSMConst.Webview.webBridgeName)
        
        
        
        //CGRect.zero
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        
        webView.navigationDelegate = context.coordinator    // 웹보기의 탐색 동작을 관리하는 데 사용하는 개체
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true  // 가로로 스와이프 동작이 페이지 탐색을 앞뒤로 트리거하는지 여부
        webView.scrollView.isScrollEnabled = true           // 웹보기와 관련된 스크롤보기에서 스크롤 가능 여부
        
        let request = URLRequest(url: url)
        // Cookies 동기화 (http api로 로그인을 실행했을 경우 쿠키를 동기화 시킨다.)
        /*for cookie in TGSURest.COOKIES {
            request.setValue(TGSUUserDefaults.getWebAppToken(), forHTTPHeaderField: TGSVWebview.COOKIES_HEADER)
        }*/
        webView.load(request)
        
        return webView
    }
    
    // 지정된 뷰의 상태를 다음의 새 정보로 업데이트 한다.
    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<TGSVWebview>) {
       
    }
    
    // 웹 메시지 인터페이스 수신
    // 웹 커맨드를 파싱하여 조절하도록 한다.
    func receivedCommandFromWebView(value: String) {
        TGSULog.log(TAG, "receive cmd : \(value)")
        viewModel.web_command.send(value)
    }
    
    /**
                탐색 변경을 수락 또는 거부하고 탐색 요청의 진행 상황을 추적
                   
     */
    public class Coordinator : NSObject, WKNavigationDelegate {
        let TAG = "TGSVWebview_Coordinator"
        
        var parent: TGSVWebview
        var call_javascript: AnyCancellable? = nil
        var should_refresh: AnyCancellable? = nil
        var should_goback: AnyCancellable? = nil
        
        var delegate: TGSPWebViewHandlerDelegate?
        
        // 생성자
        init(_ uiWebView: TGSVWebview) {
            self.parent = uiWebView
            self.delegate = parent
        }
        
        // 소멸자
        deinit {
            call_javascript?.cancel()
            should_refresh?.cancel()
            should_goback?.cancel()
        }
        
        // 지정된 기본 설정 및 작업 정보를 기반으로 새 콘텐츠를 탐색 할 수있는 권한을 대리인에게 요청
        public func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let checkDownLoadUrl = navigationAction.request.url{
                if(checkDownLoadUrl.description.hasPrefix(TGSMConst.Url.BASE_URL+"/file/download")){
                    print("파일 다운로드 시작")
                            
                    UIApplication.shared.open(checkDownLoadUrl,options: [:],completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
            }
            if let checkLoginUrl = navigationAction.request.url{
                if(checkLoginUrl.description.hasPrefix(TGSMConst.Url.BASE_URL+"/login")){
                    var haksa_url : String = TGSMConst.Url.HAKSA_URL
                    haksa_url = beforeUrl  //haksa_url + "?" + menuId
                    
                    let url  = URL(string: haksa_url)!
                    var request = URLRequest(url: url)
                    /** 세션 끊어지면 appToken 으로 동기화 하지 않고 로그아웃 처리 ( android는 동기화 하여 자동로그인 처리함) **/
                    /*for cookie in TGSURest.COOKIES {
                        request.setValue(TGSUUserDefaults.getWebAppToken(), forHTTPHeaderField: TGSVWebview.COOKIES_HEADER)
                    }*/
                    webView.load(request)
                    // Cookies 동기화 (http api로 로그인을 실행했을 경우 쿠키를 동기화 시킨다.)
                    //로그아웃 상태
                    TGSUUserDefaults.setIsSaveLogout("true")
                }
            }
            // bar에 값을 send 해보자!
            parent.viewModel.bar.send(false)

            // foo로 값이 receive 되면 출력해보자!
            self.call_javascript = self.parent.viewModel.call_javascript.receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    
                    TGSULog.log(self.TAG, "call_javascript : ", value)
                    
                    webView.evaluateJavaScript(value, completionHandler: { result, error in
                        if let anError = error {
                            TGSULog.log(self.TAG, "Error \(anError.localizedDescription)")
                        }else {
                            TGSULog.log(self.TAG, "Result \(result ?? "")")
                        }
                    })
                })
            self.should_refresh = self.parent.viewModel.should_refresh.receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    if value {
                        webView.reload()
                    }
                })
            self.should_goback = self.parent.viewModel.should_goback.receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    if(value && webView.canGoBack) {
                        webView.goBack()
                    }
                })

            return decisionHandler(.allow)
        }

        // 기본 프레임에서 탐색이 시작되었음
        public func webView(_ webView: WKWebView,
                     didStartProvisionalNavigation navigation: WKNavigation!) {
            TGSULog.log(TAG, "기본 프레임에서 탐색이 시작되었음",webView.url!)
            beforeUrl = (webView.url?.absoluteString) ?? ""
            
            parent.viewModel.web_loading.send(true)
            
        }

        // 웹보기가 기본 프레임에 대한 내용을 수신하기 시작했음
        public func webView(_ webView: WKWebView,
                     didCommit navigation: WKNavigation!) {
            TGSULog.log(TAG, "내용을 수신하기 시작",webView.url!);
        }

        // 탐색이 완료 되었음
        public func webView(_ webview: WKWebView,
                     didFinish: WKNavigation!) {
            let title = webview.title
            TGSULog.log(TAG, "탐색이 완료 - Title : \(title)")
            
            var url :String?
            url = webview.url?.absoluteString
            if(url?.hasPrefix("https://univ.namhae.ac.kr")==true){
                webview.evaluateJavaScript("$('#header').remove()")
                webview.evaluateJavaScript("$('.s_visual_img01').remove()")
                webview.evaluateJavaScript("$('.footer').remove()")
                webview.evaluateJavaScript("$('.btn_bo_user > li').remove()")
                webview.evaluateJavaScript("$('.content').attr('style','padding-top:0px;')")
            }
            parent.viewModel.web_loading.send(false)
            if (title != nil) {  parent.viewModel.web_title.send(title ?? "") }
            
            
        }

        // 초기 탐색 프로세스 중에 오류가 발생했음 - Error Handler
        public func webView(_ webView: WKWebView,
                     didFailProvisionalNavigation: WKNavigation!,
                     withError: Error) {
            TGSULog.log(TAG, "초기 탐색 프로세스 중에 오류가 발생했음",webView.url!)
            parent.viewModel.web_loading.send(false)
        }

        // 탐색 중에 오류가 발생했음 - Error Handler
        public func webView(_ webView: WKWebView,
                     didFail navigation: WKNavigation!,
                     withError error: Error) {
            TGSULog.log(TAG, "탐색 중에 오류가 발생했음")
            parent.viewModel.web_loading.send(false)
        }
        
        /// window.open 기능
        /// 새로운 웹뷰 화면으로 띄운다.
        public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if(navigationAction.request.url != nil) {
                let newCmd = "TGSFW_COMD://webBack?title=&url=\(navigationAction.request.url!)"
                self.parent.viewModel.web_command.send(newCmd)
            }
            return nil
        }
        
    }
}


//  WKScriptMessageHandler : 웹페이지에서 실행되는 javascript code에서 메세지를 수신하기 위한 인터페이스
extension TGSVWebview.Coordinator: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == TGSMConst.Webview.webBridgeName {
            if let body = message.body as? String {
                delegate?.receivedCommandFromWebView(value: body)
            }
        }
    }
}



// 알림창 출력
extension TGSVWebview.Coordinator: WKUIDelegate {
    
    // Alert 메세지를 수신 함수
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler() })
        showAlert(alert: alert)
    }
    
    // Confirm 메세지를 수신 함수
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler(true) })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in completionHandler(false) })
        showAlert(alert: alert)
    }
    
    // prompt 메세지를 수신 함수
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "알림", message: prompt, preferredStyle: .alert)
        
        var inputTextField: UITextField?
        alert.addTextField() { textField in
            textField.placeholder = defaultText
            inputTextField = textField
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in completionHandler(inputTextField?.text) })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in completionHandler(nil) })
        showAlert(alert: alert)
    }
    
    // 알림창 출력
    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    // keyWindow 획득
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
                .filter {$0.activationState == .foregroundActive}
                .compactMap {$0 as? UIWindowScene}
                .first?.windows.filter {$0.isKeyWindow}.first
    }

    // 최상위 VC 획득
    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    
}



//struct TGSVWebview_Previews: PreviewProvider {
//    
//    
//    static var previews: some View {
//        TGSVWebview(url: "https://www.naver.com", viewModel: TGSMWebviewModel(), needWebRefresh: .constant(false), needWebGoBack: .constant(false))
//    }
//}
