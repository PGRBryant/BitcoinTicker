//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Gabriel Bryant on 03/06/2018.
//  Copyright (c) 2018 Phaeroh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //Constants
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    //Variables
    var finalURL = ""
    var symbol = ""
    var bitcoinDataModel = BitcoinDataModel()
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    //TODO: UIPickerView delegate methods here
    
    //determine number of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //determine number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //the name String present in the array wil be used for display
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //what do to when you make a selection on the pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        symbol = currencySymbol[row]
        getBitcoinData(url: finalURL)
    }
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Success! Got the bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    
                    print(bitcoinJSON) //just to see the data
                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }
    
//    //MARK: - JSON Parsing
//    /***************************************************************/
    func updateBitcoinData(json : JSON) {
        
        if let lastResult = json["last"].double {
            bitcoinDataModel.price = round(100.0*lastResult)/100.0
            
            self.updateUIWithBitcoinData()
        }
    }
    
//MARK: - UI Updates
/***************************************************************/
    func updateUIWithBitcoinData() {
        self.bitcoinPriceLabel.text = "\(symbol)\(bitcoinDataModel.price)"
    }
    
}

