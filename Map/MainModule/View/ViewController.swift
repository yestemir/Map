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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.reloadMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        setupView()
        title = "Map"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(goToFolder))
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
    func goToChange(index: Int, name: String?, place: String?) {
        coordinator?.goToChange(index: index, name: name, place: place)
    }
    
    func goToCity(id: Int) {
        mainView.goToCity(id: id)
    }
    
    func changeAnnotation(id: Int, newName: String, place: String) {
        mainView.changeData(id: id, newName: newName, place: place)
    }
    
//    func goToChange(vc: UIViewController) {
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

