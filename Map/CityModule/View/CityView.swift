//
//  CityView.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import SnapKit
import CoreData

protocol CityViewDelegate {
    func goToCity(id: Int)
}

class CityView: UIView {
    var delegate: CityViewDelegate!
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        return tableView
    }()
    
    var cities = [City]()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        cities = loadCity()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCity() -> [City]{
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<City>(entityName: "City")
            do {
                cities = try context.fetch(fetchRequest)
            }catch {
                print("error")
            }
        }
        
        return cities
    }
    
    func setupView() {
        [tableView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalTo(self)
        }
        
    }
    
}


extension CityView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CityTableViewCell
        cell.titleLabel.text = cities[indexPath.row].name
        cell.placeLabel.text = cities[indexPath.row].place
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.goToCity(id: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<City>(entityName: "City")
            
            do {
                let city = try managedContext.fetch(fetchRequest)
                let objectUpdate = city[indexPath.row] as NSManagedObject
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
            
            self.setNeedsDisplay()
            
            cities.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
}
