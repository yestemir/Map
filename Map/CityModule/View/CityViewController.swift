//
//  CityViewController.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import UIKit
import SnapKit

class CityViewController: UIViewController {
    weak var coordinator: CityCoordinator?
    var cityView = CityView()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityView.delegate = self
        setupView()
    }
    
    func setupView() {
        [cityView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cityView.snp.makeConstraints { (make) in
            make.top.bottom.trailing.leading.equalTo(view)
        }
        
    }

}

extension CityViewController: CityViewDelegate {
    func goToCity(id: Int) {
        coordinator?.goToCity(id: id)
        navigationController?.popViewController(animated: true)
    }
}
