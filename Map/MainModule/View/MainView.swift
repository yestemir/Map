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
    func goToChange(index: Int, name: String?, place: String?)
    func changeTitle(name: String)
    func saveCity(name: String, place: String, long: Double, lat: Double)
    func updateCity(id: Int, name: String, place: String)
}

class MainView: UIView, UIGestureRecognizerDelegate {
    
    var viewData: MainModel = .initial {
        didSet {
            setNeedsLayout()
        }
    }
    //MARK: - inits
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        map.delegate = self
        setupView()
        setupGesture()
        putAnnotation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - props
    
    var delegate: MainViewDelegate!
    var array = [MKAnnotation]()
    
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
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch viewData {
        case .initial:
            self.map.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        case .loading:
            self.map.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        case .success(let cities):
            self.map.isHidden = false
            self.cities = cities
            map.removeAnnotations(map.annotations)
            putAnnotation()
            self.activityIndicator.stopAnimating()
        case .failure:
            self.map.isHidden = true
            self.activityIndicator.stopAnimating()
        case .updateCity(let city, let id):
            cities[id] = city
        }
    }
    
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
        
        delegate.changeTitle(name: cities[cnt].name!)
        
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
        
        delegate.changeTitle(name: cities[cnt].name!)
        
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
                self.delegate.saveCity(name: name, place: place, long: Double(coordinate.longitude), lat: Double(coordinate.latitude))
                
                let annotation = MKPointAnnotation()
                annotation.title = name
                annotation.subtitle = place
                annotation.coordinate = coordinate
                
                self.delegate.changeTitle(name: name)
                self.array.append(annotation)
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
        delegate.changeTitle(name: cities[id].name!)
        
        if cnt >= 0 && cnt < cities.count {
            let coordinate = CLLocationCoordinate2D(latitude: cities[id].latitude, longitude: cities[id].longitude)
            map.setCenter(coordinate, animated: true)
        }
    }
    
    //MARK: - CoreData
    
    var cities: [City] = []
    
    func reloadMap() {
        let allAnnotations = map.annotations
        map.removeAnnotations(allAnnotations)
        putAnnotation()
    }
    
    func putAnnotation() {
        var temp = [MKAnnotation]()
        for city in cities {
            let annotation = MKPointAnnotation()
            
            annotation.title = city.name
            annotation.subtitle = city.place
            annotation.coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
            
            temp.append(annotation)
            self.map.addAnnotation(annotation)
        }
        
        array = temp
    }
    
    //MARK: - setup
    
    func setupView() {
        
        [map, button1, button2, segment, button3, button4, activityIndicator].forEach {
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
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
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


//MARK: - extenstion put Annotation

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
        let index = (array as NSArray).index(of: view.annotation!)
        let name = view.annotation?.title
        let place = view.annotation?.subtitle
        delegate.goToChange(index: index, name: name!, place: place!)
        
    }
}

//MARK: - ChangeViewDelegate


extension MainView {
    func updateCity(id: Int, newName: String, place: String) {
        delegate.updateCity(id: id, name: newName, place: place)
        delegate.changeTitle(name: newName)
    }
    
}
