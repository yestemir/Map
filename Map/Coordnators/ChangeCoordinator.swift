//
//  ChangeCoordinator.swift
//  Map
//
//  Created by Dina Yestemir on 24.03.2021.
//

import Foundation
import UIKit

class ChangeCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var router: RouterProtocol?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var index: Int!
    var name: String!
    var place: String!
    
    init(navigationController: UINavigationController, router: RouterProtocol?) {
        self.navigationController = navigationController
        self.router = router
    }
    
    func start() {
        let vc = ChangeViewController()
        vc.coordinator = self
        vc.changeView.index = self.index
        vc.changeView.textField1.text = self.name
        vc.changeView.textField2.text = self.place
        router?.push(vc)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func change(id: Int,newName: String, place: String) {
        parentCoordinator?.changeAnnotation(id: id, newName: newName, place: place)
    }
    
    
}
