//
//  ModelRequestEncoderDelegate.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/9/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol ModelRequestEncoderDelegate {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

class ModelRequestEncoder: ModelRequestEncoderDelegate {
    
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        return try encoder.encode(value)
    }
}
