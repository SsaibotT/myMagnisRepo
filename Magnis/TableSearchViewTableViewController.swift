//
//  TableSearchViewTableViewController.swift
//  Magnis
//
//  Created by Serhii on 02.05.17.
//  Copyright © 2017 Serhii. All rights reserved.
//

import UIKit

class TableSearchViewTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var symbol = [String]()
    var filtedSymbol = [String]()
    var searchController: UISearchController!
    var resultsController = UITableViewController()
    var thisPickerSelected = ""
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchBarInTheTop()
        thickersForMe()
    }

    // MARK: - Creating TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView {
            return self.symbol.count
        } else {
            return self.filtedSymbol.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            cell.textLabel?.text = self.symbol[indexPath.row]
        } else {
            cell.textLabel?.text = self.filtedSymbol[indexPath.row]
        }

        return cell
    }
    
    //MARK: - Hiding Status Bar
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    //MARK: - Making Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
        filtedSymbol = symbol.filter{(symbol: String) -> Bool in
            if symbol.lowercased().contains(searchController.searchBar.text!.lowercased()) {
                return true
            } else if searchController.searchBar.text! == "" {
                return true
            } else {
                return false
            }
        }
        resultsController.tableView.reloadData()
    }
    
    func SearchBarInTheTop() {
        //Making search Bar in the top
        
        resultsController.tableView.dataSource = self
        resultsController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: self.resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
    }
    
    //MARK: - Making thickers
    
    func thickersForMe() {
        
        let url = URL(string: "https://s3.amazonaws.com/quandl-static-content/Ticker+CSV%27s/WIKI_tickers.csv")!
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error!)
                
            } else {
                if let returnData = String(data: data!, encoding: .utf8) {
                    let splitString = returnData.components(separatedBy: "\n")
                    for item in splitString {
                        
                        let arr = item.components(separatedBy: ",")
                        let index = arr[0].index(arr[0].startIndex, offsetBy: 5)
                        let str = arr[0].substring(from: index)
                        self.symbol.append(str)
                        
                    }
                    
                    self.symbol.remove(at: 0)
                    self.filtedSymbol = self.symbol
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                }
            }
        }.resume()
    }
    
    //MARK: - Touching the symbol Cell and going to the first View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        self.performSegue(withIdentifier: "CellToMainStoryBoardSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellToMainStoryBoardSegue" {

        let destinationController = segue.destination as! ViewController
        destinationController.companyDataMark = filtedSymbol[index]
        destinationController.gettingJsonData(thicker: destinationController.companyDataMark, server: thisPickerSelected)

        }
    }
 

}
