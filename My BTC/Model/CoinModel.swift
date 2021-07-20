//
//  CoinModel.swift
//  My BTC
//
//  Created by C. Jordan Ball III on 7/19/21.
//

import Foundation

struct CoinModel {
    let rate: Double;
    
    var rateString: String {
        return String(format: "%.2f", rate);
    }
}
