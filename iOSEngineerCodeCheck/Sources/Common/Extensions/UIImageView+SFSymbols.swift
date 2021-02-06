//
//  UIImageView+SFSymbols.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(systemName: String, tintColor: UIColor) {
        self.image = UIImage(systemName: systemName)
        self.tintColor = tintColor
    }
}
