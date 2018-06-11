//
//  ListTableViewController.swift
//  TestAssessment
//
//  Created by sandhya ganapathy on 09/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit
import SDWebImage
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
  var placeholderImage: UIImage = {
    let placeholderImg = UIImage(named: "no_Image")
    return placeholderImg!
  }()
  lazy var refreshCntrl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self,
                             action: #selector(ListTableViewController.handleRefresh(_:)),
                             for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.red
    return refreshControl
  }()
  override func viewDidLoad() {
    super.viewDidLoad()
    //TableView Property setting
    tableView.estimatedRowHeight = 286
    tableView.tableFooterView = UIView.init()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.register(ListTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.tableView.addSubview(self.refreshCntrl)
  }
   override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     // Activity Indicator
    myActivityIndicator.center = self.view.center
    myActivityIndicator.hidesWhenStopped = true
    myActivityIndicator.activityIndicatorViewStyle = .gray
    self.view.addSubview(myActivityIndicator)
    myActivityIndicator.startAnimating()
    // Webservice Call
    self.callApiToDownloadTask()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  // MARK: - API Calls
  func callApiToDownloadTask() {
    if Reachability.isConnectedToNetwork() {
      let urlString = URL(string: Constants.URLStrings.webServiceUrlString)
      let urlRequest = URLRequest(url: urlString!)
      listViewModel.fetchJsonAndSaving(urlRequest: urlRequest, completion: {(successOrFailure, responseObject) in
        if successOrFailure {
          DispatchQueue.main.async {
            print(responseObject!)
            self.tableView.reloadData()
            self.navigationTitleText = (responseObject!["title"] as? String)!
            self.myActivityIndicator.stopAnimating()
          }
        } else {
          //Failure Case
          self.myActivityIndicator.stopAnimating()
        }
      })
    } else {
      self.myActivityIndicator.stopAnimating()
      let msgString = "No Internet connection.Please check your network connection"
      let alertController = UIAlertController(title: "",
                                              message: msgString, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(defaultAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  // MARK: - Handle Refresh
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
      return  listViewModel.numberOfRowsInSection()
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ListTableViewCell
    if cell == nil {
      cell = ListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
    }
    let model = listViewModel.itemsArray[indexPath.row] as ListModel
    if let imgURLString = model.imageHref {
      let imageUrl = URL(string: imgURLString)
      cell?.imgView.sd_setShowActivityIndicatorView(true)
      cell?.imgView.sd_setIndicatorStyle(.gray)
      cell?.imgView.sd_setImage(with: imageUrl, placeholderImage: placeholderImage,
                                options: .forceTransition, completed: nil)
      cell?.titleLabel.text = listViewModel.itemsArray[indexPath.row].title
      cell?.descriptionLabel.text = listViewModel.itemsArray[indexPath.row].description
      cell?.selectionStyle = .none
      return cell!
    }
    return UITableViewCell()
  }
}
