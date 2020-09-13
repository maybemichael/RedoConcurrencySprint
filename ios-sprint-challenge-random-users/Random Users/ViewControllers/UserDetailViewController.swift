//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, Storyboarded {

    var user: User?
    var userController: UserController?
    weak var coordinator: MainCoordinator?
    
    var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        return imgView
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var numberLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        updateViews()
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(numberLabel)
        view.addSubview(emailLabel)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, padding: .init(top: 20, left: 20, bottom: 0, right: -20), size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5))
        nameLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, padding: .init(top: 20, left: 20, bottom: 0, right: -20))
        numberLabel.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, padding: .init(top: 8, left: 20, bottom: 0, right: -20))
        emailLabel.anchor(top: numberLabel.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, centerX: nil, centerY: nil, padding: .init(top: 8, left: 20, bottom: 0, right: -20))
    }
    
    private func updateViews() {
        guard let user = user else { return }
        userController?.fetchLargeImage(imageURL: user.fullSize, completion: { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        })
        nameLabel.text = user.name
        numberLabel.text = user.number
        emailLabel.text = user.email
    }
}
