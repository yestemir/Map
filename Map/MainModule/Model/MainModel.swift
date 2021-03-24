//
//  MainModel.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import Foundation

enum MainModel {
    case initial
    case loading
    case success(Data)
    case failure
    
    struct Data{
        let longitude: Double
        let latitude: Double
        let name: String
        let place: String
    }
}
