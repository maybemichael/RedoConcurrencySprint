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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        userController.fetchRandomUsers {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, centerX: nil, centerY: nil, padding: .zero, size: .zero)
        title = "Random AF Users"
        tableView.delegate = self
        tableView.dataSource = self
    }
}
