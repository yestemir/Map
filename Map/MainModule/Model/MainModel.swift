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
    case success([City])
    case updateCity(City, Int)
    case failure
}
