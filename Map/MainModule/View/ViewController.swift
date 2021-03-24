//
//  ViewController.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    var mainView = MainView()
    var viewModel: MainViewModelProtocol!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.reloadMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        setupView()
        
        viewModel = MainViewModel()
        
        updateView()
        viewModel.loadCity()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(goToFolder))
    }
    
    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.mainView.viewData = viewData
        }
    }
    
    @objc func goToFolder() {
        coordinator?.goToFolder()
    }
    
    func setupView() {
        [mainView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        mainView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(view)
            make.center.equalTo(view)
        }
    }
}

extension ViewController: MainViewDelegate {
    func saveCity(name: String, place: String, long: Double, lat: Double) {
        viewModel.saveCity(name: name, place: place, long: long, lat: lat)
    }
    
    func updateCity(id: Int, name: String, place: String) {
        viewModel.updateCity(id: id, newName: name, place: place)
    }
    
    func changeTitle(name: String) {
        self.title = name
    }
    
    func goToChange(index: Int, name: String?, place: String?) {
        coordinator?.goToChange(index: index, name: name, place: place)
        self.title = name
    }
    
    func goToCity(id: Int) {
        mainView.goToCity(id: id)
    }
    
    func changeAnnotation(id: Int, newName: String, place: String) {
        mainView.updateCity(id: id, newName: newName, place: place)
    }
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func reloadVC() {
        viewModel.loadCity()
        updateView()
    }
}


extension ViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
