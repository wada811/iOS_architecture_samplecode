//
//  Model.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import RxSwift

enum ValidationResult {
    case valid
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    var validationResult: Observable<ValidationResult>  { get }
    func validate(idText: String?, passwordText: String?)
}

final class Model: ModelProtocol {
    private let _validationResult = PublishSubject<ValidationResult>()
    var validationResult: Observable<ValidationResult>
    {
        get { return self._validationResult.asObservable() }
    }
    func validate(idText: String?, passwordText: String?) {
        switch (idText, passwordText) {
        case (.none, .none):
            self._validationResult.onNext(ValidationResult.valid)
        case (.none, .some):
            self._validationResult.onNext(ValidationResult.invalidId)
        case (.some, .none):
            self._validationResult.onNext(ValidationResult.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                self._validationResult.onNext(ValidationResult.invalidIdAndPassword)
            case (true, false):
                self._validationResult.onNext(ValidationResult.invalidId)
            case (false, true):
                self._validationResult.onNext(ValidationResult.invalidPassword)
            case (false, false):
                self._validationResult.onNext(ValidationResult.valid)
            }
        }
    }
}
