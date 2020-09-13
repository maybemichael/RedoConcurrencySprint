//
//  MainCoordinator.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var nav: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var nav: UINavigationController
    
    
    var children: [Coordinator] = []
    var coordinator: Coordinator?
    
    init(navigationController: UINavigationController) {
        self.nav = navigationController
    }
    
    func start() {
        let vc = UserViewController.instantiate()
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
    
    func userDetailView(to user: User, userController: UserController) {
        let vc = UserDetailViewController.instantiate()
        vc.user = user
        vc.userController = userController
        vc.coordinator = self
        nav.pushViewController(vc, animated: true)
    }
    
    
}
