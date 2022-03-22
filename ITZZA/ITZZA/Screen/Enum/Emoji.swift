//
//  Emoji.swift
//  ITZZA
//
//  Created by 황윤경 on 2022/03/12.
//

import UIKit

enum Emoji: CaseIterable{
    case angry
    case comfy
    case confuse
    case sad
    case lonely
}

extension Emoji {
    var color: UIColor {
        switch self {
        case .angry:
            return .seconAngry
        case .comfy:
            return .seconRelaxed
        case .confuse:
            return .seconConfused
        case .sad:
            return .seconSorrow
        case .lonely:
            return .seconLonely
        }
    }
    
    var name: String {
        switch self {
        case .angry:
            return "화남이"
        case .comfy:
            return "편안이"
        case .confuse:
            return "혼란이"
        case .sad:
            return "슬픔이"
        case .lonely:
            return "외로이"
        }
    }
    
    var StickerImage: UIImage {
        switch self {
        case .angry:
            return UIImage(named: "Sticker_angry")!
        case .comfy:
            return UIImage(named: "Sticker_comfy")!
        case .confuse:
            return UIImage(named: "Sticker_confusion")!
        case .sad:
            return UIImage(named: "Sticker_sad")!
        case .lonely:
            return UIImage(named: "Sticker_lonely")!
        }
    }
    
    var emotion: String {
        switch self {
        case .angry:
            return "화남"
        case .comfy:
            return "편안함"
        case .confuse:
            return "혼란함"
        case .sad:
            return "슬픔"
        case .lonely:
            return "외로움"
        }
    }
}
