//
//  ListModel.swift
//  TestAssessment
//
//  Created by sandhya ganapathy on 10/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import Foundation
struct ListModel {
  
  var imageHref: String?
  var title: String?
  var description: String?
  
  init(dictionary: NSDictionary) {
    
    self.imageHref = dictionary["imageHref"] as? String ?? ""
    self.description = dictionary["description"] as? String ?? ""
    self.title = dictionary["title"] as? String ?? ""
    
  }
  
}
