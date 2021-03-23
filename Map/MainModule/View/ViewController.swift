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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let tableVC = CityViewController()
        tableVC.cityView.delegate = self
        navigationController?.pushViewController(tableVC, animated: true)
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

extension ViewController: MainViewDelegate, CityViewDelegate {
    func goToCity(id: Int) {
        mainView.goToCity(id: id)
    }
    
    func goToChange(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
}

