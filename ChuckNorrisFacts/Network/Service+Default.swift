//
//  Service+Default.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 24/10/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import UIKit

extension Service {
    var baseURL: String {
        return ProcessInfo.processInfo.environment["baseURL"] ?? "https://api.chucknorris.io"
    }

    public var urlRequest: URLRequest {
        guard let url = self.url else {
            return URLRequest(url: NSURL() as URL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return request
    }

    public var urlString: String {
        return "\(urlRequest)"
    }

    public var timeout: Timeout {
        return .normal
    }

    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/jokes" + path
        if case .get = method {
            if let parameters = parameters as? [String: String] {
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
        }
        return urlComponents?.url
    }
}
