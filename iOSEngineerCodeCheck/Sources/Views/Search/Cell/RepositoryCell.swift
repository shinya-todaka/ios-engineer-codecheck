//
//  RepositoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Nuke

class RepositoryCell: ReusableTableCell {

    @IBOutlet weak var ownerImageView: UIImageView! {
        didSet {
            ownerImageView.layer.cornerRadius = 8
            ownerImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var repositoryDescriptionLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView! {
        didSet {
            starImageView.setImage(systemName: "star", tintColor: UIColor.black)
        }
    }
    
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var languageColorView: UIView! {
        didSet {
            //TODO: change color to language color
            languageColorView.backgroundColor = .gray
        }
    }
    @IBOutlet weak var languageLabel: UILabel!
    
    func configure(repository: Repository) {
        ownerNameLabel.text = repository.owner.login
        repositoryNameLabel.text = repository.name
        repositoryDescriptionLabel.text = repository.description
        
        starCountLabel.text = "\(repository.stargazersCount)"
        languageLabel.text = repository.language
        guard let ownerURL = URL(string: repository.owner.avatarUrl) else { return }
        Nuke.loadImage(with: ownerURL, into: ownerImageView)
    }
}
