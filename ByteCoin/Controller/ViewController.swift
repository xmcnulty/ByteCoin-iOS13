//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        coinManager.delegate = self
        
        let currencySelected = coinManager.currencyArray[0]
        coinManager.getCoinPrice(for: currencySelected)
    }


}

//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
}

//MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currencySelected = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: currencySelected)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price: String, curreny: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = curreny
            self.valueLabel.text = price
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.valueLabel.text = "Error"
        }
    }
    
    
}
