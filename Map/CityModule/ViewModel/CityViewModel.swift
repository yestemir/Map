//
//  CityViewModel.swift
//  Map
//
//  Created by Dina Yestemir on 24.03.2021.
//

import Foundation
import UIKit
import CoreData

protocol CityViewModelProtocol {
    var updateViewData: ((MainModel) -> Void)? { get set }
    func loadCity()
    func deleteCity(id: Int)
}

class CityViewModel: CityViewModelProtocol {
    var updateViewData: ((MainModel) -> Void)?
    var cities = [City]()
    
    func loadCity(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<City>(entityName: "City")
            do {
                cities = try context.fetch(fetchRequest)
                updateViewData?(.success(cities))
            }catch {
                print("error")
            }
        }
    }
    
    func deleteCity(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        
        do {
            let city = try managedContext.fetch(fetchRequest)
            let objectUpdate = city[id] as NSManagedObject
            managedContext.delete(objectUpdate)
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    
}
