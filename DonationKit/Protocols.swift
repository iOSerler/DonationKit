//
//  Protocols.swift
//  namaz
//
//  Created by Bekzhan Talgat on 09.11.2021.
//  Copyright © 2021 Nursultan Askarbekuly. All rights reserved.
//

import Foundation

public protocol PurchaseStorage {
    func store(_ anyObject: Any, forKey key: String)
    func retrieve(forKey key: String) -> Any?
}

public protocol AbstractAnalytics {
    func logActivity(_ activityId: String, type: String, value: Double?, startDate: Date)
    func setUserProperty(_ property: String, value: Any)
}

public protocol PurchaseViewDelegate: AnyObject {
    func startLoadingAnimation()
    func stopLoadingAnimation()
    func showPurchaseViews()
    func showFailureViews()
    func showSuccessController()
    func pop()
}
