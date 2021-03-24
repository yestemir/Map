//
//  Coordinator.swift
//  Map
//
//  Created by Dina Yestemir on 23.03.2021.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
