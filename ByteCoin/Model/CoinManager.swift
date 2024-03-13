//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, curreny: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = CoinAPI.APIKey
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    private var valueCache = CurrencyCache()
    
    var delegate: CoinManagerDelegate? = nil
    
    func getCoinPrice(for currency: String) {
        print("Getting coin price for currency: \(currency)")
        
        if let value = valueCache.getValue(for: currency) {
            print("Found cached rate for \(currency): \(value)")
            delegate?.didUpdatePrice(price: String(format: "%.2f", value), curreny: currency)
            return
        }
        
        print("Remotely fetching exchange rate for \(currency)")
        
        if let url = URL(string: urlString(for: currency)) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let e = error {
                    delegate?.didFailWithError(error: e)
                    
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    delegate?.didFailWithError(error: CoinAPIserverError())
                    return
                }
                
                if let safeData = data {
                    guard let value = parseJSON(safeData) else { return }
                    
                    valueCache.setValue(value, for: currency)
                    
                    delegate?.didUpdatePrice(price: String(format: "%.2f", value), curreny: currency)
                }
            }
            
            task.resume()
        }
    }
    
    private func urlString(for currency: String) -> String {
        return "\(baseURL)/\(currency)?apiKey=\(apiKey)"
    }
    
    private func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let coinData = try decoder.decode(CoinData.self, from: data)
            
            return coinData.rate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
