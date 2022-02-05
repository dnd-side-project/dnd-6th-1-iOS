//
//  Array+.swift
//  ITZZA
//
//  Created by InJe Choi on 2022/02/05.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    indices ~= index ? self[index] : nil
  }
}
