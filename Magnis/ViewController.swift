
//
//  ViewController.swift
//  Magnis
//
//  Created by Serhii on 02.05.17.
//  Copyright © 2017 Serhii. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var companyLabel: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableViewDatas: UITableView!

    var companyDataMark = ""
    var pickerSelected = ""
    var mass = [myMass]()
    
    let list = ["Quandl", "Google", "Yahoo", "Quotemedia"]
    var searchResult = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = "Quandl"
        companyLabel.text = companyDataMark
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mySegue" {
            let destinationController = segue.destination as! TableSearchViewTableViewController
            destinationController.thisPickerSelected = pickerSelected
        }
    }
    
    //MARK: - Making a picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textLabel.text = list[row]
        pickerSelected = list[row]
    }
    
    
    
    //MARK: - Making a tableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! TableViewCell
        
        cell.DateLabel?.text = mass[indexPath.row].dates
        cell.OpenLabel?.text = mass[indexPath.row].open
        cell.HighLabel?.text = mass[indexPath.row].high
        cell.LowLabel?.text = mass[indexPath.row].low
        cell.CloseLabel?.text = mass[indexPath.row].close
        
        return cell
    }
    
    func gettingJsonData(thicker: String, server: String) {
        if server == "Quandl" {
            let url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/\(thicker).json")
            let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
                if error != nil {
                    print("error")
                } else {
                    if let content = data {
                        let myJson = JSON(data: content)
                    
                        for item in myJson["dataset"]["data"] {
                            let objMass = myMass()
                        
                            objMass.dates = "Date: \(item.1[0].string!)"
                            objMass.open = "Open: \(String(item.1[1].double!))"
                            objMass.high = "High: \(String(item.1[2].double!))"
                            objMass.low = "Low: \(String(item.1[3].double!))"
                            objMass.close = "Close: \(String(item.1[4].double!))"
                        
                            self.mass.append(objMass)
                    
                        }
                        DispatchQueue.main.async {
                            self.tableViewDatas.reloadData()
                        }
                    
                    }
                }
                
            }
            task.resume()
        } else {
            
            var url = URL(string: "https://www.google.com/finance/historical?output=csv&q=\(thicker)")
            switch server {
            case "Yahoo":
                url = URL(string: "https://ichart.finance.yahoo.com/table.csv?d=6&e=1&g=d&a=7&b=19&ignore=.csv&s=\(thicker)")!
            case "Quotemedia":
                url = URL(string: "https://ichart.finance.yahoo.com/table.csv?d=6&e=1&g=d&a=7&b=19&ignore=.csv&s=\(thicker)")!
            default:
                print()
            }
            
            URLSession.shared.dataTask(with:url!) { (data, response, error) in
                if error != nil {
                    print(error!)
                    
                } else {
                    if let returnData = String(data: data!, encoding: .utf8) {
                        let splitString = returnData.components(separatedBy: "\n")
                        for item in splitString {
                            
                            let arr = item.components(separatedBy: ",")

                            if arr.count >= 5 {
                            let objMass = myMass()
                            objMass.dates = "Date: \(arr[0])"
                            objMass.open = "Open: \(arr[1])"
                            objMass.high = "High: \(arr[2])"
                            objMass.low = "Low: \(arr[3])"
                            objMass.close = "Close: \(arr[4])"
                            
                            self.mass.append(objMass)
                            }
                        }
                        self.mass.remove(at: 0)

                        DispatchQueue.main.async {
                            self.tableViewDatas.reloadData()
                        }
                    }
                }
            }.resume()
        }
    }
    
}

