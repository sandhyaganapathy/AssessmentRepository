//
//  ListModel.swift
//  TestAssessment
//
//  Created by Vinoth Ganapathy on 10/06/18.
//  Copyright © 2018 Gee Vee. All rights reserved.
//

import Foundation
public struct TableViewModel {
  
  public var imageHref: String?
  public var title: String?
  public var description: String?
  
  init(dictionary: NSDictionary) {
    
    self.imageHref = dictionary["imageHref"] as? String ?? ""
    self.description = dictionary["description"] as? String ?? ""
    self.title = dictionary["title"] as? String ?? ""
    
  }
  
}
