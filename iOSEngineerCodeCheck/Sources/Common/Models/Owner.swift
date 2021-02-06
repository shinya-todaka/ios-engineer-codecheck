//
//  Owner.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Owner: Decodable {
    let avatarUrl: String
    let login: String
    
    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}
