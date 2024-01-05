//
//  PassStatus.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/5/24.
//

import StoreKit
import SwiftUI

enum PassStatus: Comparable, Hashable {
    case notSubscribed
    case monthly
    case yearly

    init?(productID: Product.ID, ids: PassIdentifiers) {
        switch productID {
        case ids.monthly: self = .monthly
        case ids.yearly: self = .yearly
        default: return nil
        }
    }

    var description: String {
        switch self {
        case .notSubscribed:
            "Not Subscribed"
        case .monthly:
            "Monthly"
        case .yearly:
            "Yearly"
        }
    }
}

struct PassIdentifiers {
    var group: String

    var monthly: String
    var yearly: String
}

extension EnvironmentValues {
    private enum PassIDsKey: EnvironmentKey {
        static var defaultValue = PassIdentifiers(
            group: "21429780",
            monthly: "monthly1",
            yearly: "yearly9"
        )
    }

    var passIDs: PassIdentifiers {
        get { self[PassIDsKey.self] }
        set { self[PassIDsKey.self] = newValue }
    }
}
