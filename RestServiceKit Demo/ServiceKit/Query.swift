//
//  Query.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/6/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

class Query<A: ServiceModel> {
    
    private let service = Service.shared
    private var parameters: [URLQueryItem] = []
    private var session: URLSession {
        return URLSession.shared
    }
    
    func whereKey(_ key: AnyHashable, equalsTo value: Any) {
        parameters.append(URLQueryItem(name: "\(key)", value: "\(value)"))
    }
    
    func findAllInBackground(response: ModelResponse<[A]>) {
        session.dataTask(with: service.request(for: A.self, parameters: parameters)) { (data, _, error) in
            self.service.responseHandlerDelegate?.handleModelResponse(data: data, decoding: [A].self, error: error, response: response)
        }.resume()
    }
    
    func findObjectInBackground(with identifier: String, response: ModelResponse<A>) {
        session.dataTask(with: service.request(for: A.self, with: identifier, parameters: parameters)) { (data, _, error) in
            self.service.responseHandlerDelegate?.handleModelResponse(data: data, decoding: A.self, error: error, response: response)
        }.resume()
    }
    
    func findAllReleatedObjectsInBackground<B>(with identifier: String, relatedObjectType: B.Type, response: ModelResponse<[B]>) where B : ServiceModel {
        session.dataTask(with: service.request(for: A.self, with: identifier, relatedType: relatedObjectType, parameters: parameters)) { (data, _, error) in
            self.service.responseHandlerDelegate?.handleModelResponse(data: data, decoding: [B].self, error: error, response: response)
        }.resume()
    }
    
    func findReleatedObjectInBackground<B>(with identifier: String, relatedObjectType: B, relatedObjectIdentifier: String, response: ModelResponse<B>) where B : ServiceModel {
        session.dataTask(with: service.request(for: A.self, with: identifier, relatedType: B.self, relatedTypeIdentifier: relatedObjectIdentifier, parameters: parameters)) { (data, _, error) in
            self.service.responseHandlerDelegate?.handleModelResponse(data: data, decoding: B.self, error: error, response: response)
        }.resume()
    }
}
