//
//  ProductSubscription.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/5/24.
//

import StoreKit

actor ProductSubscription {
    static let shared = ProductSubscription()

    func status(for statuses: [Product.SubscriptionInfo.Status], ids: PassIdentifiers) -> PassStatus {
        let effectiveStatus = statuses.max { lhs, rhs in
            let lhsStatus = PassStatus(
                productID: lhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            let rhsStatus = PassStatus(
                productID: rhs.transaction.unsafePayloadValue.productID,
                ids: ids
            ) ?? .notSubscribed
            return lhsStatus < rhsStatus
        }
        guard let effectiveStatus else {
            return .notSubscribed
        }

        let transaction: Transaction
        switch effectiveStatus.transaction {
        case .verified(let t):
            transaction = t
        case .unverified(_, let error):
            print("Error occured in status(for:ids:): \(error)")
            return .notSubscribed
        }

        if case .autoRenewable = transaction.productType {
            if !(transaction.revocationDate == nil && transaction.revocationReason == nil) {
                return .notSubscribed
            }
            if let subscriptionExpirationDate = transaction.expirationDate {
                if subscriptionExpirationDate.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    return .notSubscribed
                }
            }
        }
        return PassStatus(productID: transaction.productID, ids: ids) ?? .notSubscribed
    }
}
