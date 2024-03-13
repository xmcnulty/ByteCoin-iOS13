//
//  CurrencyCache.swift
//  ByteCoin
//
//  Created by Xavier McNulty on 3/12/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

class CurrencyCache {
    private var cache = [String: (value: Double, timestamp: Date)]()
    
    // cached currency values expire after five minutes
    private let exiprationTime: TimeInterval = 5 * 60
    
    func getValue(for currency: String) -> Double? {
        if let cachedVal = self.cache[currency], cachedVal.timestamp.timeIntervalSinceNow > -exiprationTime {
            return cachedVal.value
        }
        
        return nil
    }
    
    func setValue(_ value: Double, for currency: String) {
        cache[currency] = (value, Date())
    }
}
