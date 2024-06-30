//
//  AppArguments.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation

public protocol AppArguments {
    var hostname: String { get }
    var port: Int { get }
    var inMemoryDatabase: Bool { get }
}
