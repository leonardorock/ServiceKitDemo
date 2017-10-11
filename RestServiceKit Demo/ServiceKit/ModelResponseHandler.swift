//
//  ModelResponseHandler.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/9/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol ModelResponseHandlerDelegate {
    func handleModelResponse<T>(data: Data?, decoding: T.Type, error: Error?, response: ModelResponse<T>) where T : Codable
    func handleEmptyResponse(data: Data?, error: Error?, response: EmptyResponse)
}

class ModelResponseHandler: ModelResponseHandlerDelegate {
    
    private let decoder: JSONDecoder
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    func handleModelResponse<T>(data: Data?, decoding: T.Type, error: Error?, response: ModelResponse<T>) where T : Codable {
        let result = self.resolveResponse(data: data, decoding: decoding, error: error)
        self.buildResponse(response: response, result: result)
    }
    
    func handleEmptyResponse(data: Data?, error: Error?, response: EmptyResponse) {
        if let error = error {
            response.failure(error)
        } else {
            response.success()
        }
        response.completion()
    }
    
    private func buildResponse<T>(response: ModelResponse<T>, result: (parsed: T?, error: Error?)) {
        if let parsed = result.parsed {
            response.success(parsed)
        } else if let error = result.error {
            response.failure(error)
        }
        response.completion()
    }
    
    private func resolveResponse<T>(data: Data?, decoding type: T.Type, error: Error?) -> (parsed: T?, error: Error?) where T : Codable {
        var result: T? = nil
        var error: Error? = error
        data.flatMap { data in
            do {
                if let resultsKey = Service.shared.configuration?.resultsKey,
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                    let wrappedData = json[resultsKey] {
                    let newData = try JSONSerialization.data(withJSONObject: wrappedData, options: .sortedKeys)
                    result = try decoder.decode(type, from: newData)
                } else {
                    result = try decoder.decode(type, from: data)
                }
            } catch let e {
                error = e
            }
        }
        return (result, error)
    }
}

