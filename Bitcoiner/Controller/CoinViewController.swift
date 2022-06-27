import UIKit

class CoinViewController {

  @IBOutlet weak var bitcoinLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var currencyPicker: UIPickerView!
  @IBOutlet weak var priceTextField: UILabel!
  
  var coinManager = CoinManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    currencyPicker.dataSource = self
    currencyPicker.delegate = self
    coinManager.delegate = self
  }
  
}

//MARK: - UIPickerViewDataSource

extension CoinViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencyArray.count
  }
  
}

//MARK: - UIPickerViewDelegate

extension CoinViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return coinManager.currencyArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    print("Currency selected: \(coinManager.currencyArray[row])")
    coinManager.getCoinPrice(for: coinManager.currencyArray[row])
  }
  
}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
  
  func didUpdatePrice(_ coinManager: CoinManager, coin: CoinModel) {
    DispatchQueue.main.async {
      print("Rate: \(coin.rate)")
      self.currencyLabel.text = coin.assetIdQuote
      self.priceTextField.text = String(format: "%.2f", coin.rate)
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
  
}

