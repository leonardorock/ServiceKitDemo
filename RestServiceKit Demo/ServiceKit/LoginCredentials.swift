//
//  LoginCredentials.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/19/17.
//  Copyright © 2017 KeyCar. All rights reserved.
//

import Foundation

protocol LoginCredentials: ServiceModel {
    associatedtype Model : ServiceModel
}

extension LoginCredentials {
    
    static var identifierKeyPath: AnyKeyPath? {
        return nil
    }
    
    var session: URLSession {
        return .shared
    }
    
    var service: Service {
        return .shared
    }
    
    func login<Model>(response: ModelResponse<Model>) where Model : ServiceModel {
        var request = service.request(for: Self.self, method: .post)
        let encoder = service.requestEncoderDelegate
        do {
            request.httpBody = try encoder?.encode(self)
            let task = session.dataTask(with: request) { (data, urlResponse, error) in
                self.service.responseHandlerDelegate?.handleModelResponse(data: data, urlResponse: urlResponse, decoding: Model.self, error: error, response: response)
            }
            task.resume()
        } catch {
            response.failure(error)
        }
    }
    
}
