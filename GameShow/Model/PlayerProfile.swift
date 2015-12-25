//
//  PlayerProfile.swift
//  GameShow
//
//  Created by Jonathan Jemson on 12/24/15.
//  Copyright © 2015 Jonathan Jemson. All rights reserved.
//

import UIKit

public class PlayerProfile : NSObject {
    var score: Int = 0
    var name: String
    
    init(name: String) {
        self.name = name
    }
}