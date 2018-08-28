//
//  UIResponser+Extension.swift
//  Amiibo
//
//  Created by Gustavo Campos on 8/28/18.
//  Copyright © 2018 gcamposApps. All rights reserved.
//

import UIKit


extension UIResponder {
    
   @objc func selectedAmiibo(_ parameter: Any) {
        self.next?.selectedAmiibo(parameter)
    }
}
