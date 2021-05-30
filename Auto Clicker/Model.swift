//
//  Model.swift
//  Auto Clicker
//
//  Created by Tej on 25/12/20.
//

import Foundation
struct Task : Codable{
    var xAxis : Double = 0
    var yAxis : Double = 0
    var numRepeat : Int32 = 1
    var actionIndex : Int = 0
    var delay : Int32 = 0
    var comment : String = ""
}
