//
//  UserViewController.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, Storyboarded {

    let cache = Cache<String, UIImage>()
    var operations = Dictionary<String, Operation>()
    let userController = UserController()
    let photoQueue = OperationQueue()
    weak var coordinator: MainCoordinator?
    let width: CGFloat = UIScreen.main.bounds.width
    let tableViewCell = UITableViewCell(style: .default, reuseIdentifier: UserTableViewCell.reuseIdentifier)
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    typealias UsersDataSource = UITableViewDiffableDataSource<Int, User>
    typealias UsersSnapshot = NSDiffableDataSourceSnapshot<Int, User>
    
    lazy var dataSource: UsersDataSource = {
        let dataSource = UsersDataSource(tableView: tableView) { tableView, indexPath, user -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else { return nil }
            let user = self.userController.users[indexPath.row]
            cell.user = user
            self.loadImage(forCell: cell, forItemAt: indexPath)
            return cell
        }
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        userController.fetchRandomUsers {
            DispatchQueue.main.async {
                self.setupDiffDatasource()
            }
        }
    }
    
    private func setupDiffDatasource() {
        var snapshot = UsersSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(userController.users)
        dataSource.apply(snapshot)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, centerX: nil, centerY: nil, padding: .zero, size: .zero)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        title = "Random AF Users"
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    func loadImage(forCell cell: UserTableViewCell, forItemAt indexPath: IndexPath) {
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
