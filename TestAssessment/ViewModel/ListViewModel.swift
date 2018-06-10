//
//  ListViewModel.swift
//  TestAssessment
//
//  Created by sandhya ganapathy on 10/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import UIKit

class ListViewModel: NSObject {
  
  var itemsArray = [ListModel]()
  
  //MARK: - APIClient call
  
  func fetchJsonAndSaving(urlRequest: URLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()){
    
    APIClient.client.fetchDataTask(urlRequest: urlRequest, completion:{ (successOrFailure,responseObject) in
      
      if successOrFailure{
        if let items = responseObject!["rows"] as? [[String:Any]] {
          
          completion(true,responseObject)
          for item in items{
            let model = ListModel(dictionary: item as NSDictionary )
            self.itemsArray.append(model)
          }
        }
      }else{
        //Failure Case
      }
    })
  }
  
  func numberOfRowsInSection() -> Int {
    return itemsArray.count
  }

}
