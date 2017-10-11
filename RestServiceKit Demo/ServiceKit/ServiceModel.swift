//
//  ServiceModel.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/6/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol ServiceModel: Codable {
    static var serviceClassName: String { get }
}

extension ServiceModel {
    static var query: Query<Self> {
        return Query<Self>()
    }
    
    private var session: URLSession {
        return URLSession.shared
    }
    
    func includeInBackground(response: ModelResponse<Self>) {
        saveInBackground(method: .post, response: response)
    }
    
    func updateInBackground(identifier: String, response: ModelResponse<Self>) {
        saveInBackground(method: .put, identifier: identifier, response: response)
    }
    
    func deleteInBackground(identigier: String, response: EmptyResponse) {
        let service: Service = Service.shared
        let request = service.request(for: Self.self, with: identigier, method: .delete)
        session.dataTask(with: request) { (data, _, error) in
            service.responseHandlerDelegate?.handleEmptyResponse(data: data, error: error, response: response)
        }
    }
    
    private func saveInBackground(method: HTTPMethod, identifier: String? = nil, response: ModelResponse<Self>) {
        let service = Service.shared
        var request = service.request(for: Self.self, with: identifier, method: method)
        do {
            request.httpBody = try service.requestEncoderDelegate?.encode(self)
            session.dataTask(with: request) { (data, _, error) in
                service.responseHandlerDelegate?.handleModelResponse(data: data, decoding: Self.self, error: error, response: response)
            }.resume()
        } catch {
            response.failure(error)
        }
    }
    
}

