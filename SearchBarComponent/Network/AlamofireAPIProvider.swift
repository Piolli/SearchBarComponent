//
//  AlamofireAPIProvider.swift
//  SearchBarComponent
//
//  Created by Alexandr on 09.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AlamofireAPIProvider : APIProvider {
    
    func searchGoods(query: String, completionHandler: @escaping ([JSON]?, Error?) -> Void) {
        
        let headers: HTTPHeaders = [
            //todo: store in keychain
            "AccessKey": "test_05fc5ed1-0199-4259-92a0-2cd58214b29c",
            "IDCategory": "",
            "IDClient": "",
            "pageNumberIncome": "1",
            "pageSizeIncome": "12"
        ]
        
        let params: Parameters = [
            "SearchString": query
        ]
        
        Alamofire.request(
            NetworkEndpoint.searchProductsByCategory.url(),
            method: .get,
            parameters: params,
            headers: headers
        ).response(queue: .global(qos: .userInitiated), completionHandler: { (dataResponse) in
                guard let data = dataResponse.data else {
                    completionHandler(nil, dataResponse.error)
                    return
                }
                
                let json = try? JSON(data: data)
                let results = json?["data"]["listProducts"].arrayValue
                if let results = results, results.isEmpty {
                    completionHandler(nil, NSError(domain: "AlamofireAPIProvider", code: 100, userInfo: ["description": "Не найдено товаров с таким запросом"]))
                    return
                }

                completionHandler(results, nil)
            })
        }
    
}
