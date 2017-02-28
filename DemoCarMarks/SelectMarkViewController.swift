//
//  SelectMarkViewController.swift
//  DemoCarMarks
//
//  Created by Dima on 28/02/2017.
//  Copyright © 2017 Dmitriy Rozov. All rights reserved.
//

import UIKit

class SelectMarkViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.setBackgraundView()
            tableView.tableFooterView = UIView()
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.barStyle = .black
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    let api = API()
    let markService = MarkService()
    var marks = [Mark]()
    var filteredMarks = [Mark]()
    
    var tableViewState: TableViewState = .loading {
        didSet {
            switch tableViewState {
            case .loading:
                activityIndicator.startAnimating()
                errorLabel.text = ""
                self.tableView.isHidden = true
            case .list:
                activityIndicator.stopAnimating()
                errorLabel.text = ""
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.tableView.isHidden = false
            case .error(let error):
                activityIndicator.stopAnimating()
                errorLabel.text = error
                self.tableView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        getMarks()
    }
    
    // MARK: - Helpers
    
    func getMarks() {
        tableViewState = .loading
        markService.get(completionHandler: { result in
            
            switch result {
            case .success(let items):
                self.marks = items
                self.tableViewState = .list
            case .error(let error):
                self.tableViewState = .error(error.rawValue)
                
                if error == ErrorType.noInternet {
                    API().networkReachability(completionHandler: {_ in
                        self.getMarks()
                    })
                }
            }
        })
    }
    
    func filterContentFowrSearchText(_ searchText: String) {
        filteredMarks = marks.filter({( mark : Mark) -> Bool in
            return mark.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "selectMarkSegue") {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let selectModelVC = segue.destination as! SelectModelViewController
//                selectModelVC.markID = marks[indexPath.row].id
//                tableView.deselectRow(at: indexPath, animated: true)
//            }
        }
    }
}

// MARK: - TableView

extension SelectMarkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredMarks.count
        }
        return marks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MarkTableViewCell
        
        let mark: Mark
        if searchController.isActive && searchController.searchBar.text != "" {
            mark = filteredMarks[indexPath.row]
        } else {
            mark = marks[indexPath.row]
        }
        
        cell.name = mark.name
        return cell
    }
}

// MARK: - SearchBar

extension SelectMarkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredMarks = marks.filter({( mark : Mark) -> Bool in
            return mark.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        tableView.reloadData()
    }
}
