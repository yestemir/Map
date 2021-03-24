//
//  MainViewModel.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//


import Foundation
import UIKit
import CoreData
import MapKit

protocol MainViewModelProtocol {
    var updateViewData: ((MainModel) -> Void)? { get set }
    func loadCity()
    func saveCity(name: String, place: String, long: Double, lat: Double)
    func updateCity(id: Int, newName: String, place: String)
}

class MainViewModel: MainViewModelProtocol {
    
    var updateViewData: ((MainModel) -> ())?
    var cities = [City]()
    
    init() {
        updateViewData?(.initial)
    }
    
    func loadCity() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<City>(entityName: "City")
            do {
                cities = try context.fetch(fetchRequest)
                updateViewData?(.success(cities))
            }catch {
                updateViewData?(.failure)
                print("error")
            }
        }
    }
    
    
    func saveCity(name: String, place: String, long: Double, lat: Double) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            if let entity = NSEntityDescription.entity(forEntityName: "City", in: context) {
                let city = NSManagedObject(entity: entity, insertInto: context)
                city.setValue(name, forKey: "name")
                city.setValue(place, forKey: "place")
                city.setValue(long, forKey: "longitude")
                city.setValue(lat, forKey: "latitude")
                do{
                    try context.save()
                    cities.append(city as! City)
                    updateViewData?(.success(cities))
                }catch{
                    updateViewData?(.failure)
                    print("error")
                }
            }
            
        }
    }
    
    func updateCity(id: Int, newName: String, place: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        do {
            cities = try managedContext.fetch(fetchRequest)
            let objectUpdate = cities[id] as NSManagedObject
            objectUpdate.setValue(newName, forKey: "name")
            objectUpdate.setValue(place, forKey: "place")
            do {
                try managedContext.save()
                updateViewData?(.updateCity(objectUpdate as! City, id))
            }
            catch {
                updateViewData?(.failure)
                print(error)
            }
        }catch {
            updateViewData?(.failure)
            print(error)
        }
    }
    
    
}
