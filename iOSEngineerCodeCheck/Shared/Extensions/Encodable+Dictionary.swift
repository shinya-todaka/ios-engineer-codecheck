//
//  Encodable+Dictionary.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Encodable {
  var dictionaryRepresentation: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }

    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
      .flatMap { $0 as? [String: Any] }
  }
}
