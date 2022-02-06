//
//  Data+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/01/30.
//

import Foundation

extension Data {
  func decode<T: Decodable>(_ type: T.Type,
                            keyStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyStrategy
    return try? decoder.decode(type, from: self)
  }
}

