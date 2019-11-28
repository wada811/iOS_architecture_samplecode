//
//  ViewModel.swift
//  RxSimpleSample
//
//  Created by Kenji Tanaka on 2018/10/08.
//  Copyright © 2018年 Kenji Tanaka. All rights reserved.
//

import UIKit
import RxSwift

final class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    let disposeBag = DisposeBag()

    init(idTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         model: ModelProtocol) {
        Observable
            .combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .subscribe(onNext: {(idText: String?, passwordText: String?) -> Void in
                model.validate(idText: idText, passwordText: passwordText)
            })
            .disposed(by: disposeBag)

        self.validationText = model.validationResult
            .map { result -> String in result.validationResultText }
            .startWith("IDとPasswordを入力してください。")

        self.loadLabelColor = model.validationResult
            .map { result -> UIColor in result.validationResultColor }
    }
}

extension ValidationResult {
    fileprivate var validationResultText: String {
        switch self {
        case .valid:
            return "OK!!!"
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です。"
        }
    }
    fileprivate var validationResultColor: UIColor {
        switch self {
            case .valid:
                return .green
            default:
                return .red
        }
    }
}
