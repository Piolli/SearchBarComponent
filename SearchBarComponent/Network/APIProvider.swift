//
//  APIProvider.swift
//  SearchBarComponent
//
//  Created by Alexandr on 09.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol APIProvider {
    
    func searchGoods(query: String, completionHandler: @escaping ([JSON]?, Error?) -> Void)
    
}


