//
//  TGSURest.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/11.
//
import Foundation
import Alamofire
import UIKit

//MARK: RestApi를 사용하는 객체
enum TGSERestFailType {
    case FAIL
}

public struct APIResult: Codable {
    public let success: Bool
    public let message: String
    public let result: Result?
    
    public struct Result :Codable{
        public let userFg : String?
        public let pass : String?
        public let userPushFg : String?
    }
    
}



/// Alamofire 라이브러리를 사용
public class TGSURest {
    let TAG  = "[TGSURest]"
    
    public static let shared = TGSURest()
    
    public static var COOKIES:[HTTPCookie] = []
    public static var HEADER: HTTPHeaders = ["Content-Type": "application/json", "Accept":"application/json"]
    
    
    
    private init() {
        
    }
    
//    AF.upload : 멀티파트, 스트림, 파일 메소드를 통해 파일을 업로드 한다
//    AF.download : 파일을 다운로드 하거나, 이미 진행중인 다운로드를 재개한다
//    AF.request : 파일과 관련없는 기타 HTTP 요청
    
    //let params: Parameters = [ "userId" : 1,"id" : 1]
    public func GET(url:String, params:Parameters = [:], isSaveCookies:Bool = false, onSuccess: @escaping (APIResult)->Void, onFail: @escaping (APIResult)->Void) {
        TGSULog.log(TAG, "GET url : \(url)")
        TGSULog.log(TAG, "GET params : \(params)")
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: TGSURest.HEADER)
            .validate(statusCode: 200..<300)                //200~500사이 상태만 허용
            .validate(contentType: ["application/json"])    //JSON 포맷만 허용
            .responseData { response in
                self.onResponseCompletion(response: response, onSuccess: onSuccess, onFail: onFail, isSaveCookies: isSaveCookies, saveCookiesUrl: url)
            }
    }
    
    //let params: Parameters = [ "userId" : 1,"id" : 1]
    public func POST(url:String, params:Parameters = [:], isSaveCookies:Bool = false, onSuccess: @escaping (APIResult)->Void, onFail: @escaping (APIResult)->Void) {
        TGSULog.log(TAG, "POST url : \(url)")
        TGSULog.log(TAG, "POST params : \(params)")
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: TGSURest.HEADER)
            .validate(statusCode: 200..<300)                //200~500사이 상태만 허용
            .validate(contentType: ["application/json"])    //JSON 포맷만 허용
            .responseData { response in
                self.onResponseCompletion(response: response, onSuccess: onSuccess, onFail: onFail, isSaveCookies: isSaveCookies, saveCookiesUrl: url)
                
            }
    }
    
    
    // 이미지업로드
    public func UPLOAD(url:String, params:Parameters = [:], images:[UIImage], onSuccess: @escaping (APIResult)->Void, onFail: @escaping (APIResult)->Void) {
        TGSULog.log(TAG, "UPLOAD url : \(url)")
        TGSULog.log(TAG, "UPLOAD params : \(params)")
        
        let header : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            // 파라미터 전송
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            // 업로드 이미지 전송
            for img in images {
                if let image = img.pngData() {
                    multipartFormData.append(image, withName: "images", fileName: "\(image).png", mimeType: "image/png")
                } else if let image = img.jpegData(compressionQuality: 100) {
                    multipartFormData.append(image, withName: "images", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                }
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
        .validate()
        .responseData { response in
            self.onResponseCompletion(response: response, onSuccess: onSuccess, onFail: onFail)
            
        }
    }
    
    public func DOWNLOAD(url:String) {
        let fileManager = FileManager.default
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName : String = URL(string: url)!.lastPathComponent /** url의 마지막 문자열로 이름 지정 */
        let fileURL = appURL.appendingPathComponent(fileName)

        /** 파일 경로 지정 및 다운로드 옵션 설정 (이전 파일 삭제, 디렉토리 생성) */
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(url,
                    method: .get,
                    parameters: nil,
                    encoding: JSONEncoding.default,
                    to: destination)
        .downloadProgress { progress in
            /** 다운로드 progress */
            /** progressView를 사용할 때 여기에 작성 */
            print(progress)
        }.response{ response in
            print(response)
            if response.error != nil {
                /** 파일 다운로드 실패*/
            } else{
                /** 파일 다운로드 성공*/
            }
        }
    }
    
    //모든 통신을 결과 전송 규약에 따라 같은 Model을 선택하고 있으므로 하나로 통일한다.
    private func onResponseCompletion(response: AFDataResponse<Data>, onSuccess: @escaping (APIResult)->Void, onFail: @escaping (APIResult)->Void, isSaveCookies:Bool = false, saveCookiesUrl:String = "") {
        switch response.result {
        case .success(let res):
            do {
                let code = response.response?.statusCode ?? 0
                let jsonResult = String(data: res, encoding: .utf8) ?? ""
                TGSULog.log("응답코드 : \(code)")
                TGSULog.log("응답데이터 : \(jsonResult)")
                let appToken = response.response?.headers.value(for: "appToken") ?? ""
                TGSUUserDefaults.setWebAppToken(appToken)
                // 쿠키 저장 여부
                if(isSaveCookies) {
                    TGSURest.COOKIES = HTTPCookieStorage.shared.cookies ?? []
                    // 저장된 쿠키를 바로 Alamofire 쿠키에 저장하여 다음 요청부터 세션이 적용되도록 한다.
                    AF.session.configuration.httpCookieStorage?.setCookies(TGSURest.COOKIES, for:URL(string: saveCookiesUrl), mainDocumentURL: nil)
                }
                
                let objResult = try JSONDecoder().decode(APIResult.self, from: res)
                if objResult.success {
                    onSuccess(objResult)
                } else {
                    onFail(objResult)
                }

                // 비동기작업 수행
                //DispatchQueue.main.async { }
            } catch (let err){
                TGSULog.log("오류 : catchf \(err.localizedDescription)")
                onFail(APIResult(success: false, message: "서버 장애로 통신이 원활하지 않습니다./n잠시후에 다시 시도하시기 바랍니다.", result: APIResult.Result(userFg: "", pass: "", userPushFg: "")))
            }
            break
        case .failure(let err):
            TGSULog.log("응답코드 : \(response.response?.statusCode ?? 0)")
            TGSULog.log("에러 : \(err.localizedDescription)")
            onFail(APIResult(success: false, message: "인터넷 연결이 불안정합니다./n잠시후에 다시 시도하시기 바랍니다.", result: APIResult.Result(userFg: "", pass: "", userPushFg: "")))
        }
    }
    
    
}
