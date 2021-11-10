//
//  PurchaseHistory.swift
//
//  Created by Daniya on 04/11/2021.
//  Copyright © 2021 Nursultan Askarbekuly. All rights reserved.
//

import Foundation

public struct PurchaseHistory {
        
    static func markPurchase(_ purchaseId: String?) {

        if let purchaseId = purchaseId {
        
            /// mark purchase id for the assoicated bonus item
        
            UserDefaults.standard.setValue(true, forKey: purchaseId)
        } else {
            /// mark the general fact of support
            UserDefaults.standard.setValue(true, forKey: "didSupportApp")
        }
        
        UserDefaults.standard.synchronize()

    }
    
    static func checkPurchase(_ purchaseId: String? = nil) -> Bool {
        
        guard let purchaseId = purchaseId else {
            return UserDefaults.standard.bool(forKey: "didSupportApp")
        }
        
        return UserDefaults.standard.bool(forKey:purchaseId)
    }
    

}
