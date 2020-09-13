//
//  TableView+DSandDelegate.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userController.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else { fatalError() }
        let user = userController.users[indexPath.row]
        cell.user = user
        loadImage(forCell: cell, forItemAt: indexPath)
        
        return cell
    }
    
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
    
    private func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
        let user = userController.users[indexPath.row]
        let id = user.id
        if let image = cache.getValue(for: id) {
            if self.tableView.indexPath(for: cell) == indexPath {
                cell.userImageView.image = image
                return
            }
        }
        
        let fetchUserPhoto = FetchUserPhotoOperation(user: user)
        let cacheUserPhoto = BlockOperation {
            if let image = fetchUserPhoto.image {
                self.cache.setValue(for: id, value: image)
            }
        }
        
        let setUserPhoto = BlockOperation {
            defer { self.operations.removeValue(forKey: id) }
            
            if let currentIndexPath = self.tableView.indexPath(for: cell), currentIndexPath != indexPath {
                print("Cell was reused")
                return
            }
            
            if let image = fetchUserPhoto.image {
                cell.userImageView.image = image
            }
        }
        cacheUserPhoto.addDependency(fetchUserPhoto)
        setUserPhoto.addDependency(fetchUserPhoto)
        photoQueue.addOperations([fetchUserPhoto, cacheUserPhoto], waitUntilFinished: false)
        OperationQueue.main.addOperation(setUserPhoto)
        operations[id] = fetchUserPhoto
    }
}
