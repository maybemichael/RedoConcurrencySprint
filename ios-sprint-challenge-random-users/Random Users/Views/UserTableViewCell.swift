//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Michael McGrath on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    var userImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        return imgView
    }()
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .detailDisclosureButton
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        userImageView.frame = CGRect(x: 0, y: 0, width: 57, height: 57)
        userImageView.anchor(top: nil, leading: contentView.leadingAnchor, trailing: nil, bottom: nil, centerX: nil, centerY: contentView.centerYAnchor, padding: .init(top: 8, left: 20, bottom: -8, right: 0), size: .init(width: 50, height: 50))
        userNameLabel.anchor(top: nil, leading: userImageView.trailingAnchor, trailing: contentView.trailingAnchor, bottom: nil, centerX: nil, centerY: contentView.centerYAnchor, padding: .init(top: 20, left: 8, bottom: -20, right: -20), size: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) not implemented")
    }

    private func updateViews() {
        guard let user = user else { return }
        userNameLabel.text = user.name
    }
}
