//
//  Board.swift
//  Pluto
//
//  Created by Faisal Lalani on 9/14/16.
//  Copyright © 2016 Faisal M. Lalani. All rights reserved.
//

import Foundation

class Board {
    
    private var _name: String!
    
    var name: String {
        
        return _name
    }
    
    init(name: String) {
        
        self._name = name
    }
}
