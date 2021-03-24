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
    var router: RouterProtocol?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, router: RouterProtocol?) {
        self.navigationController = navigationController
        self.router = router
    }
    
    func start() {
        let vc = CityViewController()
        let navVC = UINavigationController(rootViewController: vc)
        vc.coordinator = self
        navVC.modalPresentationStyle = .overCurrentContext
        router?.present(navVC)
//        navigationController.viewControllers.last?.present(navVC, animated: false)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCity(id: Int) {
        parentCoordinator?.goToCity(id: id)
    }
    
    func reloadMain() {
        parentCoordinator?.reloadMain()
    }
}
