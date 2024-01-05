//
//  Enums.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/12/23.
//

import SwiftUI
import StoreKit

enum PeriodProduct: String, Codable, CaseIterable {
    case cup
    case pad
    case tampon
    case underwear
}

enum AppIcons: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case primaryInverted = "AppIconInverted"
    case babyBlueOnWhite = "BabyBlueOnWhite"
    case whiteOnBabyBlue = "WhiteOnBabyBlue"
    case greenOnWhite = "GreenOnWhite"
    case whiteOnGreen = "WhiteOnGreen"
    case pinkOnWhite = "PinkOnWhite"
    case whiteOnPink = "WhiteOnPink"
    case pride = "Pride"
    case prideInverted = "PrideInverted"
    case grayOnWhite = "GrayOnWhite"
    case whiteOnGray = "WhiteOnGray"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .primary:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .primary:
            return "Default"
        case .primaryInverted:
            return "Default Inverted"
        case .grayOnWhite:
            return "Gray on White"
        case .whiteOnGray:
            return "White on Gray"
        case .babyBlueOnWhite:
            return "Baby Blue on White"
        case .whiteOnBabyBlue:
            return "White on Baby Blue"
        case .greenOnWhite:
            return "Green on White"
        case .whiteOnGreen:
            return "White on Green"
        case .pride:
            return "Pride"
        case .prideInverted:
            return "Pride Inverted"
        case .pinkOnWhite:
            return "Pink On White"
        case .whiteOnPink:
            return "White On Pink"
        }
    }

    var preview: UIImage {
        UIImage(named: rawValue + "-Preview") ?? UIImage()
    }
}

//public struct PassIdentifiers: Sendable {
//    public var group: String
//    
//    public var individual: String
//    public var family: String
//    public var premium: String
//}
//
//enum PassStatus: Comparable, Hashable {
//    case notSubscribed
//    case individual
//    case family
//    case premium
//    
//    init(levelOfService: Int) {
//        self = switch levelOfService {
//        case 1: .premium
//        case 2: .family
//        case 3: .individual
//        default: .notSubscribed
//        }
//    }
//    
//    init?(productID: Product.ID, ids: PassIdentifiers) {
//        switch productID {
//        case ids.individual: self = .individual
//        case ids.family: self = .family
//        case ids.premium: self = .premium
//        default: return nil
//        }
//    }
//}
//
//public extension EnvironmentValues {
//    
//    private enum PassIDsKey: EnvironmentKey {
//        static var defaultValue = PassIdentifiers(
//            group: "21429780",
//            individual: "pass.individual",
//            family: "pass.family",
//            premium: "pass.premium"
//        )
//    }
//    
//    var passIDs: PassIdentifiers {
//        get { self[PassIDsKey.self] }
//        set { self[PassIDsKey.self] = newValue }
//    }
//    
//}
