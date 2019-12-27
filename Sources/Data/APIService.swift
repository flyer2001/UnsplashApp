//
//  APIService.swift
//  UnsplashApp
//
//  Created by Sergey Popyvanov on 24.12.2019.
//  Copyright © 2019 Sergey Popyvanov. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

struct CustomError: Error, Decodable {
    var errors: [String?]
}

final public class APIService {
    
    public static let shared = APIService()
    
    let sessionManager = SessionManager.default
    
    func getObject<T:Decodable>(
        url: URL?,
        params: Parameters,
        handler: @escaping (Swift.Result<T, Error>) -> Void) {
        if let resultURL = url {
            request(resultURL, method: .get, parameters: params).responseData(){ response in
                    response.result.withValue { data in
                        do {
                            if let responseError = response.response?.statusCode {
                                if responseError != 200 {
                                        let error = try JSONDecoder.init().decode(CustomError.self, from: data)
                                        handler(.failure(error))
                                        return
                                    } else {
                                        let result = try JSONDecoder.init().decode(T.self, from: data)
                                        handler(.success(result))
                                        return
                                    }
                                }
                        } catch (let error) {
                            handler(.failure(error))
                            return
                        }
                    }.withError { error in
                        handler(.failure(error))
                    }
            }
        }

    }
    
    func parsingStringFromHTML(
        url: URL?,
        filterText: String,
        handler: @escaping (Swift.Result<[String], Error>) -> Void){
        if let resultUrl = url {
            let URLTask = URLSession.shared.dataTask(with: resultUrl){
                data, response, error in
                do {
                    if let dataSource = data {
                        if let sourceHTMLString = String(data: dataSource, encoding: String.Encoding.utf8){
                            let doc = try HTML(html: sourceHTMLString, encoding: .utf8)
                            var resultStringArray: [String] = []
                            for link in doc.xpath("//a | //link") {
                                if let text = link.text  {
                                    if text == filterText{
                                        if let filteredString = link["href"]{
                                            resultStringArray.append(filteredString)
                                        }
                                        
                                    }
                                }
                                
                            }
                            handler(.success(resultStringArray))
                        }
                    }
                    
                } catch (let error) {
                    handler(.failure(error))
                }
                
            }
            URLTask.resume()
        }
    
    }
    
}
