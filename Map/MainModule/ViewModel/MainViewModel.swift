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
    func setParams(longitude: Double, latitude: Double, name: String, description: String)
}

class MainViewModel: MainViewModelProtocol {
    var updateViewData: ((MainModel) -> ())?
    var longitude = Double()
    var latitude = Double()
    var name = String()
    var place = String()
    
    init() {
        updateViewData?(.initial)
    }
    
    func startFech() {
        updateViewData?(.loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.updateViewData?(.success(MainModel.Data(longitude: self.longitude, latitude: self.latitude, name: self.name, place: self.place)))
        }
    }
    
    func setParams(longitude: Double, latitude: Double, name: String, description: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.place = description
    }
    
    
}
