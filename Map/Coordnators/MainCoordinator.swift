//
//  MainCoordinator.swift
//  Map
//
//  Created by Dina Yestemir on 23.03.2021.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var router: RouterProtocol?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, router: RouterProtocol?) {
        self.navigationController = navigationController
        self.router = router
    }
    
    let vc = ViewController()
    
    func start() {
        navigationController.delegate = self // going back
        vc.coordinator = self
        router?.push(vc)
//        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFolder() {
        let child = CityCoordinator(navigationController: navigationController, router: router)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func goToChange(index: Int, name: String?, place: String?) {
        let child = ChangeCoordinator(navigationController: navigationController, router: router)
        child.index = index
        child.name = name
        child.place = place
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func goToCity(id: Int) {
        vc.goToCity(id: id)
    }
    
    func changeAnnotation(id: Int, newName: String, place: String) {
        vc.changeAnnotation(id: id, newName: newName, place: place)
    }
    
    func reloadMain() {
        vc.reloadVC()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for(index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let cityViewController = fromViewController as? CityViewController {
            childDidFinish(cityViewController.coordinator)
        }
        
        if let changeViewController = fromViewController as? ChangeViewController {
            childDidFinish(changeViewController.coordinator)
        }
    }
}
