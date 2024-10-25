//
//  File.swift
//  bookstore-hummingbird
//
//  Created by Moritz Ellerbrock on 04.08.24.
//

import Foundation

extension MockFactory {
    enum Books {
        @discardableResult
        static func create(userId: UUID,
                           permission: PermissionLevel,
                           client: some TestClientProtocol) async throws -> QuickLinkPartResponse
        {
            try await client.execute(uri: "/users/\(userId.uuidString)/quicklinks/\(permission.path)", method: .post) { response in
                guard response.status == .created else {
                    Self.logger.error("ERROR-CODE: \(response.status)")
                    throw Factory.GeneralError.statusCodeMismatch(response.status.code)
                }
                return try JSONDecoder().decode(QuickLinkPartResponse.self, from: response.body)
            }
        }

        @discardableResult
        static func getList(userId: UUID,
                            client: some TestClientProtocol) async throws -> QuickLinkListResponse
        {
            try await client.execute(uri: "/users/\(userId.uuidString)/quicklinks", method: .get) { response in
                guard response.status == .ok else {
                    Self.logger.error("ERROR-CODE: \(response.status)")
                    throw Factory.GeneralError.statusCodeMismatch(response.status.code)
                }
                return try JSONDecoder().decode(QuickLinkListResponse.self, from: response.body)
            }
        }

        @discardableResult
        static func get(userId: UUID,
                        linkPart: String,
                        client: some TestClientProtocol) async throws -> QuickLinkInfoResponse
        {
            try await client.execute(uri: "/users/\(userId)/quicklinks/\(linkPart)", method: .get) { response in
                guard response.status == .ok else {
                    Self.logger.error("ERROR-CODE: \(response.status)")
                    throw Factory.GeneralError.statusCodeMismatch(response.status.code)
                }
                return try JSONDecoder().decode(QuickLinkInfoResponse.self, from: response.body)
            }
        }

        @discardableResult
        static func update(userId: UUID,
                           linkPart: String,
                           permission: PermissionLevel,
                           client: some TestClientProtocol) async throws -> HTTPResponse.Status
        {
            try await client.execute(uri: "/users/\(userId)/quicklinks/\(linkPart)/\(permission.path)", method: .patch) { response in
                response.status
            }
        }

        @discardableResult
        static func post(linkPart: String,
                         url: String,
                         client: some TestClientProtocol) async throws -> WebsiteResponse
        {
            let request = QuickLinkPostRequest(url: url)
            let buffer = try JSONEncoder().encodeAsByteBuffer(request, allocator: ByteBufferAllocator())
            return try await client.execute(uri: "/quicklink/\(linkPart)", method: .post, body: buffer) { response in
                guard response.status == .created else {
                    Self.logger.error("ERROR-CODE: \(response.status)")
                    throw Factory.GeneralError.statusCodeMismatch(response.status.code)
                }
                return try JSONDecoder().decode(WebsiteResponse.self, from: response.body)
            }
        }
    }
}
