//
//  ApiError.swift
//  lunch-machine
//
//  Created by Duc Do on 8.2.2024.
//

import Foundation

struct ApiError: Error {
    var statusCode: Int
    let errorCode: String
    var message: String

    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }

    var errorCodeNumber: String {
        return errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

extension ApiError: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
        statusCode = 0
    }
}
