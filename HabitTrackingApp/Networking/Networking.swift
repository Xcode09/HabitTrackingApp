
import UIKit
import Alamofire
enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
    case actionNotallowed
    case paymentIsNotDone
    case connectionTimeOut
}
extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .paymentIsNotDone:
            return ""
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
            
        case .actionNotallowed:
            return "Action is not allow for this type of action"
        case .connectionTimeOut:
            return "Connection time out. Kindly check your internet connection"
        }
        
        
    }
}
extension ServiceError {
    init(json: [String:Any]) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}



final class Networking{
    private init(){}
    static let shareInstance = Networking()
    var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type":"application/json"
    ]
    
    //MARK:- Fetch Data
    func callNetwork<T:Codable>(uri :String,method:HTTPMethod = .get, parameters:[String:Any]=[:],completionHandler: @escaping (Result<T>) -> Void)
    {
        Alamofire.request(uri, method:method, parameters:method == .get ? nil:parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (Response) in
            switch Response.result{
            case .success:
                if let data = Response.data{
                    do{
                        let jsn = try JSONDecoder.init().decode(T.self, from: data)
                        completionHandler(.success(jsn))
                    }catch let error{
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                if Response.response?.statusCode  == NSURLErrorTimedOut
                {
                    completionHandler(.failure(ServiceError.connectionTimeOut))
                }else{
                    do{
                        guard let data = Response.data else {
                            return
                        }
                        let jsn = try JSONDecoder.init().decode(ErrorModel.self, from: data)
                        completionHandler(.failure(ServiceError.custom(jsn.message ?? "")))
                    }catch let error{
                        completionHandler(.failure(error))
                    }
                    completionHandler(.failure(error))
                }
                
            }
        }
    }
    
    
    func postDataWithImage<T:Codable>(uri :String,method:HTTPMethod = .get,imageData : Data = Data(), parameters:[String:String]=[:],completionHandler: @escaping (Result<T>) -> Void){
        
        Alamofire.upload(multipartFormData: { (mutlipart) in
            
            mutlipart.append(imageData, withName: "image", fileName: "fileios.jpg", mimeType: "image/jpg")
            
            for (key, value) in parameters {
                if let data = value.data(using: .utf8) {
                    mutlipart.append(data, withName: key)
                }
            }
        }, to: uri,method: .post,headers: headers) {
            (result) in
            switch result {
            case .success(let upload, _, _):
                upload.validate().responseJSON { (resultData) in
                    switch resultData.result{
                    case .success:
                        guard let myData = resultData.data else{
                            return
                        }
                        do{
                            let jsn = try JSONDecoder.init().decode(T.self, from: myData)
                            completionHandler(.success(jsn))
                        }
                        catch{
                            completionHandler(.failure(ServiceError.custom(error.localizedDescription)))
                        }
                    case .failure:
                        do{
                            guard let data = resultData.data else {
                                return
                            }
                            let jsn = try JSONDecoder.init().decode(ErrorModel.self, from: data)
                            completionHandler(.failure(ServiceError.custom(jsn.message ?? "")))
                        }catch let error{
                            completionHandler(.failure(error))
                        }
                    }
                    
                }
            case .failure(let error):
                completionHandler(.failure(ServiceError.custom(error.localizedDescription)))
            }
        }
    }
}

/*
 
 */
