//
//  Response+Encodable.swift
//  
//
//  Created by Moritz Ellerbrock
//

import Foundation
import HTTPTypes
import Hummingbird

extension Response {
    init( with codable: Codable?, status: HTTPResponse.Status = .ok, headers: HTTPFields = .init()) {
        var body: ResponseBody = .init()
        var headers: HTTPFields = headers

        if let codable, let data = try? JSONEncoder().encode(codable) {
            let byteBuffer = ByteBuffer(data: data)
            body = .init(byteBuffer: byteBuffer)
            headers.append(.init(name: .contentType, value: "application/json"))
        }

        self.init(status: status, headers: headers, body: body)
    }
}
