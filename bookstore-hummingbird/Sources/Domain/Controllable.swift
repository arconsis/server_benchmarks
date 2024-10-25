//
//  File.swift
//  
//
//  Created by Moritz Ellerbrock on 31.05.24.
//

import Foundation
import Hummingbird

public protocol Controllable {
    func addRoutes(to router: Router<BasicRequestContext>)
}
