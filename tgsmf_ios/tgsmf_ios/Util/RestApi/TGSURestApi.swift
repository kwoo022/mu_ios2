import Foundation
import Moya

// 제공 api 선언
enum APIService {
    case login(id : String, passwd:String)
    case qrCheckIn(qrcode : String)
}




extension APIService : TargetType {
    var headers: [String : String]? {
        //return nil
        //return ["Content-Type": "application/json"]
        switch self {
        case .login(_, _):
            return ["Content-Type": "application/json"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    // 기본 도메인 작성
    var baseURL: URL {
        return URL(string: "http://118.47.55.173:3002")!
        //        switch self {
        //        case .version , .post , .parameter:
        //            return URL(string: "https://jsonplaceholder.typicode.com")!
        //        case .download :
        //            return URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf")!
        //        }
    }
    
    // api별 기본 path 정의
    var path: String {
        switch self{
        case .login :
            return "login"
        case .qrCheckIn :
            return "qrCheckIn"
        
        }
    }
    
    //어떤 방식의 통신인지 설정
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .qrCheckIn :
            return .get
        }
    }
    
    //
    var sampleData: Data {
        
        return  "sampleData".data(using: .utf8)!
        
    }
    
    // 데이터 전송 형식 지정 : 어떻게 데이터를 전송할 것인가?
    //    1. requestPlain : 기본적으로 어떤 값을 넣지 않을 때 사용합니다. (주로 GET)
    //    2. requestData : Body에 데이터를 담아서 보낼 때 사용합니다. (주로 POST)
    //    3. requestParameters : 파라미터를 전송할때 사용. (주로 GET)
    var task: Task {
        switch self {
        case .login(id: let id, passwd: let passwd):
            //return .requestData(data)
            //return .requestJSONEncodable(requestDataModel)
            return .requestParameters(parameters: ["id" : id, "password":passwd], encoding: URLEncoding.queryString)
        case .qrCheckIn(qrcode: let qrCode):
            return .requestParameters(parameters: ["qrcode" : qrCode], encoding: URLEncoding.queryString)
            //            case .version:
            //                return .requestPlain
            //            case .post(let data):
            //                return .requestData(data)
            //            case .parameter(postId: let postId):
            //                return .requestParameters(parameters: ["postId" : postId, "hello":postId], encoding: URLEncoding.queryString)
            //            case .download:
            //                return .downloadDestination { temporaryURL, response in
            //                    TGSULog.log("temporaryURL : \(temporaryURL.absoluteString)")
            //                    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            //                    let desination = directory.appendingPathComponent("SwiftDocument.pdf")
            //                    return (desination , [.removePreviousFile])
            //                }
            //            }
        }
        
        // 헤더에 추가적은 값을 전달할때
//        var headers: [String : String]? {
//            return nil
//        }
        
    }
}




