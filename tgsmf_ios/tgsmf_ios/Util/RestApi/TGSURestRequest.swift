import Foundation
import Moya

struct APIResultModel: Codable {
    let success: Bool
    let message: String
    let result: Result
    
    struct Result : Codable{
        let userFg : String
        let pass : String
    }
}

class CustomPlugIn : PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        TGSULog.log("[TGSUREstRequest_CustomPlugIn] ","URL Request = \(target) : \(request.url?.absoluteString ?? "없음")")
        return request
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        TGSULog.log("[TGSUREstRequest_CustomPlugIn] ","URL Response = \(target) : \(result)")
        return result
    }
}

class NetworkWrapper<Provider : TargetType> : MoyaProvider<Provider> {
    
    init(endPointClosure : @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         stubClosure : @escaping StubClosure = MoyaProvider.neverStub,
         plugins : [PluginType] ){
        
        let session = MoyaProvider<Provider>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 20
        session.sessionConfiguration.timeoutIntervalForResource = 20
        
        super.init(endpointClosure: endPointClosure, stubClosure: stubClosure, session: session, plugins: plugins)
    }
    
    func requestSuccessRes<Model : Codable>(target : Provider, instance : Model.Type , completion : @escaping(Result<Model, MoyaError>) -> () ){
        self.request(target) { result in
            switch result {
                
            case .success(let response):
                
                if (200..<300).contains(response.statusCode) {
                    TGSULog.log( "Status Code : \(response.statusCode)")
                    if let decodeData = try? JSONDecoder().decode(instance, from: response.data) {
                        completion(.success(decodeData))
                    }
                    else{
                        completion(.failure(.requestMapping("디코딩오류")))
                    }
                }
                else{
                    completion(.failure(.statusCode(response)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestDownload(target : Provider, progress : @escaping ProgressBlock, completion : @escaping(Bool) -> ()){
        self.request(target, progress: progress) { result in
            switch result {
                
            case .success(let response):
                
                if (200..<300).contains(response.statusCode) {
                    TGSULog.log("[TGSUREstRequest_requestDownload] ","Status Code : \(response.statusCode)")
                    completion(true)
                    
                }
                else{
                    completion(false)
                }
                
            case .failure(_):
                completion(false)
            }
        }
    }
    
}


