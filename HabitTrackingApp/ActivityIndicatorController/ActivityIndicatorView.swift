//
//  ActivityIndicatorView.swift
//  Sosyal
//
//  Created by Muhammad Ali on 29/09/2019.
//  Copyright © 2019 Muhammad Ali Rana. All rights reserved.
//

import Foundation
import SKActivityIndicatorView
struct ActivityController {
 
    init(){
        SKActivityIndicator.spinnerColor(.black)
        SKActivityIndicator.statusTextColor(.black)
    }
 func showIndicator(){
    SKActivityIndicator.show("Please wait ...", userInteractionStatus: false)
  }
  func dismissIndicator(){
    SKActivityIndicator.dismiss()
  }
}
