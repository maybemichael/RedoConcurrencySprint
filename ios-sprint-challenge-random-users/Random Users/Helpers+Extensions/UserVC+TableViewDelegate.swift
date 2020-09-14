//
//  TableView+DSandDelegate.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

extension UserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let userID = userController.users[indexPath.row].id
        operations[userID]?.cancel()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        coordinator?.userDetailView(to: user, userController: userController)
    }
}
