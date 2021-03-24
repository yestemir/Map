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
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        view.isOpaque = false
        cityView.delegate = self
        setupView()
        title = "Cities"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(goToFolder))
    }
    
    @objc func goToFolder() {
        navigationController?.dismiss(animated: false, completion: nil)
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
        navigationController?.dismiss(animated: false, completion: nil)
//        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
}
