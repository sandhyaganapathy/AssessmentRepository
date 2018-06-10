//
//  ListTableViewController.swift
//  TestAssessment
//
//  Created by Vinoth Ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
  
  //Cell Identifier
  let cellIdentifier: String = "CellIdentifier"
  var listViewModel: ListViewModel = ListViewModel()
  let myActivityIndicator = UIActivityIndicatorView()
  var navigationTitleText: String = "" {
    didSet {
      self.title = navigationTitleText
    }
  }
 
  
  lazy var refreshCntrl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(ListTableViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.red
    
    return refreshControl
  }()
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Webservice Call
    self.callApiToDownloadTask()
    
    //TableView Property setting
    tableView.estimatedRowHeight = 286
    tableView.backgroundColor = UIColor.init(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    tableView.tableFooterView = UIView.init()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.register(ListTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    self.tableView.addSubview(self.refreshCntrl)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    myActivityIndicator.center = self.view.center
    myActivityIndicator.hidesWhenStopped = true
    myActivityIndicator.activityIndicatorViewStyle = .whiteLarge
    self.view.addSubview(myActivityIndicator)
    myActivityIndicator.startAnimating()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - API Calls
  func callApiToDownloadTask() {
    let urlString = URL(string: Constants.URLStrings.WEB_SERVICE_URL_STRING)
    let urlRequest = URLRequest(url: urlString!)
    listViewModel.fetchJsonAndSaving(urlRequest: urlRequest, completion: {(successOrFailure,responseObject) in
      
      if successOrFailure{
        DispatchQueue.main.async {
          self.tableView.reloadData()
          self.navigationTitleText = responseObject!["title"] as! String
          self.myActivityIndicator.stopAnimating()
        }
      }
    })
  }
  //MARK: - Handle Refresh
  @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
    listViewModel.itemsArray.removeAll()
    self.callApiToDownloadTask()
    refreshControl.endRefreshing()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 5
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ListTableViewCell?
    
    if cell == nil {
      cell = ListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
    }
    cell?.textLabel?.text = "sample"


    return cell!
  }
 

}
