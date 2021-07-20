//
//  ViewController.swift
//  My BTC
//
//  Created by C. Jordan Ball III on 7/19/21.
//

import UIKit

class MainVC: UIViewController, UIPickerViewDataSource {

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var resDisplay: UILabel!
    @IBOutlet weak var currencyDisplay: UILabel!
    @IBOutlet weak var resultStack: UIStackView!
    
    let constants = Constants();
    var coinManager = CoinManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self;
        currencyPicker.delegate = self;
        coinManager.coinDelegate = self;
        
        resultStack.layer.cornerRadius = 8;
        
    }
}

extension MainVC: UIPickerViewAccessibilityDelegate {
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return constants.currencyArray.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return constants.currencyArray[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = constants.currencyArray[row];
        currencyDisplay.text = selectedCurrency;
        coinManager.fetchCoinPrice(for: selectedCurrency);
    }
}

extension MainVC: CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, rate: CoinModel) {
        DispatchQueue.main.async {
            print("Rate!");
            self.resDisplay.text = rate.rateString;
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription);
    }
}

