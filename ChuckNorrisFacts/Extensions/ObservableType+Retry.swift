//
//  ObservableType+Retry.swift
//  ChuckNorrisFacts
//
//  Created by Lucas César  Nogueira Fonseca on 05/11/19.
//  Copyright © 2019 Lucas César  Nogueira Fonseca. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func retry(_ maxAttemptCount: Int = 1, when: @escaping (Error) -> Observable<Error>) -> Observable<Element> {
        return retryWhen { errorObservable -> Observable<Error> in
            var retries = maxAttemptCount
            return errorObservable.flatMap { error -> Observable<Error> in
                guard retries > 0 else { return Observable.error(error) }
                retries -= 1
                return when(error)
            }
        }
    }
}
