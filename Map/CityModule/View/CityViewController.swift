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
    var viewModel: CityViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 1, alpha: 0.5)
        view.isOpaque = false
        title = "Cities"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(goToFolder))
        
        
        cityView.delegate = self
        setupView()
        
        viewModel = CityViewModel()
        updateView()
        viewModel.loadCity()
    }
    
    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.cityView.viewData = viewData
        }
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
    func deleteCity(id: Int) {
        viewModel.deleteCity(id: id)
        coordinator?.reloadMain()
    }
    
    func goToCity(id: Int) {
        coordinator?.goToCity(id: id)
        navigationController?.dismiss(animated: false, completion: nil)
//        dismiss(animated: true, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
}

extension CityViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
    
}


extension UINavigationController: Presentable{
    func toPresent() -> UIViewController? {
        return self
    }
}
