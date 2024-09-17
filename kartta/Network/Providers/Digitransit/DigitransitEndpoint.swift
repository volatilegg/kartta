//
//  DigitransitEndpoint.swift
//  kartta
//
//  Created by Duc Do on 17.9.2024.
//

import Foundation

enum DigitransitEndpoint: EndpointProvider {
    case autocomplete

    var baseURL: String {
        return "api.digitransit.fi/routing/v1/routers"
    }

    var path: String {
        return "hsl/index/graphql"
    }

    var token: String {
        return "a7e21ebc167f4862bf47d670ea63a918"
    }

    var method: RequestMethod {
        switch self {
            case .autocomplete:
                return .get
        }
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }

    var body: [String: Any]? {
        return nil
    }

    var mockFile: String? {
        return nil
    }
}
