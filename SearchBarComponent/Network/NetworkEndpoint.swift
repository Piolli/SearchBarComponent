//
//  Network.swift
//  SearchBarComponent
//
//  Created by Alexandr on 09.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation

enum NetworkEndpoint : String {
    
    case searchProductsByCategory = "http://iswiftdata.1c-work.net/api/products/searchproductsbycategory"
    
    func url() -> String {
        return self.rawValue
    }
}
