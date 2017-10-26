//
//  NetworkError.swift
//  RestServiceKit Demo
//
//  Created by Leonardo Oliveira on 10/18/17.
//  Copyright © 2017 KeyCar. All rights reserved.
//

import Foundation

struct NetworkError: LocalizedError {
    let statusCode: Int
    var errorDescription: String? {
        return HTTPURLResponse.localizedString(forStatusCode: statusCode)
    }
    var data: Data?
}

