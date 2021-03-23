//
//  MainViewModel.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//


import Foundation
import UIKit

protocol MainViewModelProtocol {
    var updateViewData: ((MainModel) -> Void)? { get set }
    func startFech()
    func setParams(longitude: String, latitude: String, name: String, description: String)
}

class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((MainModel) -> ())?
    var longitude = String()
    var latitude = String()
    var name = String()
    var description = String()
    
    init() {
        updateViewData?(.initial)
    }
    
    func startFech() {
        updateViewData?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.updateViewData?(.success(MainModel.Data(longitude: self.longitude, latitude: self.latitude, name: self.name, description: self.description)))
        }
    }
    
    func setParams(longitude: String, latitude: String, name: String, description: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.description = description
    }
    
    
}
