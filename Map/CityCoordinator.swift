//
//  CityCoordinator.swift
//  Map
//
//  Created by Dina Yestemir on 23.03.2021.
//

import Foundation
import UIKit

class CityCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CityViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCity(id: Int) {
        parentCoordinator?.goToCity(id: id)
    }
}
