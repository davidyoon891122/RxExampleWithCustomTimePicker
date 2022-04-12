//
//  CustomViewModel.swift
//  CustomePicker
//
//  Created by iMac on 2022/04/12.
//

import Foundation
import RxSwift
import RxCocoa

protocol CustomViewModelInputs {
    var closeButtonInRelay: PublishRelay<Void> { get }
    var completButtonInRelay: PublishRelay<String> { get }
    var hourTextFieldInRelay: PublishRelay<String> { get }
}

protocol CustomViewModelOutputs {
    var closeButtonOutReply: PublishRelay<Void> { get }
    var completButtonOutRelay: PublishRelay<Void> { get }
}

class CustomViewModel: CustomViewModelInputs, CustomViewModelOutputs {
    var hourText: PublishRelay<String> = .init()

    var hourTextFieldInRelay: PublishRelay<String> = .init()

    private let disposeBag = DisposeBag()

    var completButtonInRelay: PublishRelay<String> = .init()

    var completButtonOutRelay: PublishRelay<Void> = .init()

    var closeButtonOutReply: PublishRelay<Void> = .init()

    var closeButtonInRelay: PublishRelay<Void> = .init()

    func handleCloseButton() {
        closeButtonInRelay
            .bind(to: closeButtonOutReply)
            .disposed(by: disposeBag)
    }

    func handleHourTextField() {
        hourTextFieldInRelay
            .map(trimHour)
            .map {
                self.checkHour($0) ? $0 : ""
            }
            .bind(to: hourText)
            .disposed(by: disposeBag)
    }

    func handleCompleteButton() {
        completButtonInRelay
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    func trimHour(_ hour: String) -> String {
        if hour.count > 2 {
            let index = hour.index(hour.startIndex, offsetBy: 2)
            return String(hour[..<index])
        } else {
            return hour
        }
    }

    func checkHour(_ result: String) -> Bool {
        if Int(result) ?? 0 > 12  || Int(result) ?? 0 < 0 {
            return false
        }
        return true
    }

    func checkMinute(_ result: String) -> Bool {
        if Int(result) ?? 0 > 59 || Int(result) ?? 0 < 0 {
            return false
        }
        return true
    }
}
