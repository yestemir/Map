//
//  MainView.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import MapKit
import SnapKit
import CoreData

protocol MainViewDelegate {
    func presentAlert(alert: UIAlertController)
    func goToChange(vc: UIViewController)
}

class MainView: UIView, UIGestureRecognizerDelegate {
    
    //MARK: - inis
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        map.delegate = self
        setupView()
        setupGesture()
        loadCity()
        putAnnotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - props
    
    var delegate: MainViewDelegate!
    
    private var map = MKMapView()
    private var button1: MapButton = {
        let button = MapButton(buttonImage: "minus")
        button.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        
        return button
    }()
    
    private var button2: MapButton = {
        let button = MapButton(buttonImage: "plus")
        button.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        
        return button
    }()
    
    private var button3: MapButton = {
        let button = MapButton(buttonImage: "arrow.left")
        button.addTarget(self, action: #selector(prevPlace), for: .touchUpInside)
        
        return button
    }()
    
    private var button4: MapButton = {
        let button = MapButton(buttonImage: "arrow.right")
        button.addTarget(self, action: #selector(nextPlace), for: .touchUpInside)
        
        return button
    }()
    
    let segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Standard", "Sattellite", "Hybrid"])
        segment.addTarget(self, action: #selector(changeSegment(sender:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    //MARK: - custom funcs
    
    var cnt = 0
    
    @objc func prevPlace() {
        var region: MKCoordinateRegion = map.region
        region.span.latitudeDelta = min(0.5, 180.0)
        region.span.longitudeDelta = min(0.5, 180.0)
        map.setRegion(region, animated: false)
        
        if cnt >= 0 && cnt < cities.count {
            let coordinate = CLLocationCoordinate2D(latitude: cities[cnt].latitude, longitude: cities[cnt].longitude)
            map.setCenter(coordinate, animated: true)
        }
        
        if cnt > 0 {
            cnt -= 1
        }else{
            cnt = cities.count - 1
        }
        
    }
    
    @objc func nextPlace() {
        var region: MKCoordinateRegion = map.region
        region.span.latitudeDelta = min(0.5, 180.0)
        region.span.longitudeDelta = min(0.5, 180.0)
        map.setRegion(region, animated: false)
        
        if cnt >= 0 && cnt < cities.count {
            let coordinate = CLLocationCoordinate2D(latitude: cities[cnt].latitude, longitude: cities[cnt].longitude)
            map.setCenter(coordinate, animated: true)
        }
        
        if cnt < cities.count - 1 {
            cnt += 1
        }else{
            cnt = 0
        }
    }
    
    @objc func zoomIn() {
        var region: MKCoordinateRegion = map.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        map.setRegion(region, animated: true)
    }
    
    @objc func zoomOut() {
        var region: MKCoordinateRegion = map.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        map.setRegion(region, animated: true)
    }
    
    @objc func changeSegment(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            map.mapType = .standard
        case 1:
            map.mapType = .satellite
        default:
            map.mapType = .hybrid
        }
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self.map)
        let coordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        let alert = UIAlertController(title: "Enter City?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the city name here..."
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input the place here..."
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text, let place = alert.textFields?.last?.text {
                self.saveCity(name: name, place: place, long: Double(coordinate.longitude), lat: Double(coordinate.latitude))
                
                let annotation = MKPointAnnotation()
                annotation.title = name
                annotation.subtitle = place
                annotation.coordinate = coordinate
                
                self.map.addAnnotation(annotation)
            }
            
            
        }))
        delegate.presentAlert(alert: alert)
    }
    
    
    func goToCity(id: Int) {
        var region: MKCoordinateRegion = map.region
        region.span.latitudeDelta = min(0.5, 180.0)
        region.span.longitudeDelta = min(0.5, 180.0)
        map.setRegion(region, animated: false)
        
        if cnt >= 0 && cnt < cities.count {
            let coordinate = CLLocationCoordinate2D(latitude: cities[id].latitude, longitude: cities[id].longitude)
            map.setCenter(coordinate, animated: true)
        }
    }
    
    //MARK: - CoreData
    
    var cities: [City] = []
    
    func loadCity() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<City>(entityName: "City")
            do {
                cities = try context.fetch(fetchRequest)
            }catch {
                print("error")
            }
        }
    }
    
    func reloadMap() {
        loadCity()
        let allAnnotations = map.annotations
        map.removeAnnotations(allAnnotations)
        putAnnotation()
    }
    
    func putAnnotation() {
        for city in cities {
            let annotation = MKPointAnnotation()
            annotation.title = city.name
            annotation.subtitle = city.place
            annotation.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
            
            self.map.addAnnotation(annotation)
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
                }catch{
                    print("error")
                }
            }
            
        }
    }
    
    //MARK: - setup
    
    func setupView() {
        
        [map, button1, button2, segment, button3, button4].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        map.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(self)
            make.center.equalTo(self)
        }
        
        button1.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(segment.snp.top).offset(-30)
            make.width.height.equalTo(50)
        }
        
        button2.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(button1.snp.top).offset(-20)
            make.width.height.equalTo(50)
        }
        
        segment.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.height.equalTo(30)
        }
        
        button3.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.width.height.equalTo(50)
        }
        
        button4.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    
    func setupGesture() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressRecognizer.minimumPressDuration = 0.3
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        self.map.addGestureRecognizer(longPressRecognizer)
    }
}


//MARK: - extenstion

extension MainView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        
        annotationView?.image = UIImage(named: "pin")
        annotationView?.canShowCallout = true
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let changeVC = ChangeViewController()
        changeVC.changeView.index = (self.map.annotations as NSArray).index(of: view.annotation!)
        changeVC.changeView.name = (view.annotation?.title)!
        changeVC.changeView.textField1.text = (view.annotation?.title)!
        changeVC.changeView.textField2.text = (view.annotation?.subtitle)!
        changeVC.delegate = self
        delegate.goToChange(vc: changeVC)
    }
}

//MARK: - ChangeViewDelegate


extension MainView: ChangeViewDelegate {
    func changeData(id: Int, name: String, newName: String, place: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        
        do {
            cities = try managedContext.fetch(fetchRequest)
            let objectUpdate = cities[id] as NSManagedObject
            
//            for (i, city) in cities.enumerated() {
//                if city.name == name {
//                    objectUpdate = cities[i] as NSManagedObject
//                    break
//                }
//            }
            objectUpdate.setValue(newName, forKey: "name")
            objectUpdate.setValue(place, forKey: "place")
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }catch {
            print(error)
        }
        
        self.setNeedsDisplay()
    }
    
    
    
}
