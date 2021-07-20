//
//  CoinManager.swift
//  My BTC
//
//  Created by C. Jordan Ball III on 7/19/21.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, rate: CoinModel);
    func didFailWithError(error: Error);
}

struct CoinManager {
    
    let privates = Private();
    let constants = Constants();
    var coinDelegate: CoinManagerDelegate?;
    
    let crypto = "BTC";
    
    func fetchCoinPrice(for currency: String) {
        let url = "\(constants.baseURL)/\(crypto)/\(currency)?apikey=\(privates.apiKey)"
        performRequest(url);
    }
    
    func performRequest(_ urlString: String) {
        print("urlString: \(urlString)");
        // i) create the url
        if let url = URL(string: urlString) {
            // ii) create Session
            let session = URLSession(configuration: .default);
            // iii) create a task
            let fetchTask = session.dataTask(with: url) { (data, response, error) in
                if (error != nil) {
                    print(error!.localizedDescription);
                    return;
                }
                if let safeData = data {
                    if let rateData = self.parseJSON(safeData) {
                        print("rateData: \(rateData)");
                        self.coinDelegate?.didUpdateRate(self, rate: rateData);
                    }
                }
            }
            // iv) run the task
            fetchTask.resume();
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder();
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData);
            let rate = decodedData.rate;
            let rateData = CoinModel(rate: rate);
            return rateData;
        } catch {
            print(error);
            return nil;
        }
        
    }
}
