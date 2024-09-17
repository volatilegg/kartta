//
//  BaseNetworkService.swift
//  lunch-machine
//
//  Created by Duc Do on 8.2.2024.
//

import Foundation
import OSLog

protocol ApiProtocol {
    func asyncRequest<T: Decodable>(
        endpoint: EndpointProvider,
        responseModel: T.Type
    ) async throws -> T
}

final class ApiClient: ApiProtocol {
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        // seconds that a task will wait for data to arrive
        configuration.timeoutIntervalForRequest = 60
        // seconds for whole resource request to complete ,.
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }

    func asyncRequest<T: Decodable>(
        endpoint: EndpointProvider,
        responseModel: T.Type
    ) async throws -> T {
        do {
            let (data, response) = try await session.data(for: endpoint.asURLRequest())
            return try self.manageResponse(data: data, response: response)
        } catch let error as ApiError {
            throw error
        } catch {
            throw ApiError(
                errorCode: "ERROR-0",
                message: "Unknown API error: \(error.localizedDescription)"
            )
        }
    }

    private func manageResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw ApiError(
                errorCode: "ERROR-0",
                message: "Invalid HTTP response"
            )
        }
        switch response.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    Logger.network.error("‼️ \(error.localizedDescription)")
                    throw ApiError(
                        errorCode: "error-decoding-data",
                        message: "Error decoding data"
                    )
                }
            default:
                guard let decodedError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                    Logger.network.error("‼️ Unknown backend error")
                    throw ApiError(
                        statusCode: response.statusCode,
                        errorCode: "ERROR-0",
                        message: "Unknown backend error"
                    )
                }
                Logger.network.error(
                    "‼️ Backend error - \(response.statusCode): \(decodedError.message)"
                )
                throw ApiError(
                    statusCode: response.statusCode,
                    errorCode: decodedError.errorCode,
                    message: decodedError.message
                )
        }
    }
}
