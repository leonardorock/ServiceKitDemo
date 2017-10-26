//
//  ModelRequestJSONEncoder.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/9/17.
//  Copyright © 2017 Leonardo Oliveira. All rights reserved.
//

import Foundation

protocol ModelRequestEncoderDelegate {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

class ModelRequestJSONEncoder: ModelRequestEncoderDelegate {
    
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        return try encoder.encode(value)
    }
}

enum URLEncoderError: Error {
    case unableToConvertToDictionary, unableToCreateQueryString
}

class ModelRequestURLEncoder: ModelRequestEncoderDelegate {
    
    let encoder: JSONEncoder
    
    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let data = try encoder.encode(value)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
            throw URLEncoderError.unableToConvertToDictionary
        }
        var nonNullValuesDictionary: [String : Any] = [:]
        dictionary.forEach { key, value in
            if !(value is NSNull) {
                nonNullValuesDictionary[key] = value
            }
        }
        guard let queryStringData = nonNullValuesDictionary.queryParameters.data(using: .utf8) else {
            throw URLEncoderError.unableToCreateQueryString
        }
        print(String(data: queryStringData, encoding: .utf8)!)
        return queryStringData
    }
}
