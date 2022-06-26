import Foundation

protocol CoinManagerDelegate {
  func didUpdatePrice(_ coinManager: CoinManager, coin: CoinModel)
  func didFailWithError(error: Error)
}

struct CoinManager {
  
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
  let apiKey = "E65E4C9B-10B9-4121-8475-BF0FBB44FC88"
  
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  
  var delegate: CoinManagerDelegate?
  
  func getCoinPrice(for currency: String) {
    let url = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
    performRequest(with: url)
  }
  
  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let coin = self.parseJSON(safeData) {
            self.delegate?.didUpdatePrice(self, coin: coin)
          }
        }
      }
      task.resume()
    }
  }
  
  func parseJSON(_ coinData: Data) -> CoinModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(CoinData.self, from: coinData)
      let assetIdQuote = decodedData.asset_id_quote
      let rate = decodedData.rate
      
      let coin = CoinModel(assetIdQuote: assetIdQuote, rate: rate)
      
      return coin
      
    } catch {
      delegate?.didFailWithError(error: error)
      
      return nil
    }
  }
}
