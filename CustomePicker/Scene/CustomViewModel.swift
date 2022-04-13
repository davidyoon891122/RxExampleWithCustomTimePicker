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
    var hourTextFieldInRelay: PublishRelay<String> { get }
    var minuteTextFieldInRelay: PublishRelay<String> { get }
}

protocol CustomViewModelOutputs {
    var closeButtonOutReply: PublishRelay<Void> { get }
    var completeButtonOutRelay: PublishRelay<Void> { get }
    var completeResultOutRelay: PublishRelay<String> { get}
}

protocol CustomViewModelType {
    var inputs: CustomViewModelInputs { get }
    var outputs: CustomViewModelOutputs { get }

}

class CustomViewModel: CustomViewModelType, CustomViewModelInputs, CustomViewModelOutputs {
    var hourText: PublishRelay<String> = .init()

    var minuteText: PublishRelay<String> = .init()

    // IN
    var closeButtonInRelay: PublishRelay<Void> = .init()

    var hourTextFieldInRelay: PublishRelay<String> = .init()

    var minuteTextFieldInRelay: PublishRelay<String> = .init()

    // OUT
    var closeButtonOutReply: PublishRelay<Void> = .init()

    var completButtonOutRelay: PublishRelay<Void> = .init()

    var completeButtonOutRelay: PublishRelay<Void> = .init()

    var completeResultOutRelay: PublishRelay<String> = .init()

    var inputs: CustomViewModelInputs { return self }

    var outputs: CustomViewModelOutputs { return self }

    private let disposeBag = DisposeBag()

    func handleHourTextField() {
        hourTextFieldInRelay
            .map(setTimePickerMaxLength)
            .map {
                self.checkHour($0) ? $0 : ""
            }
            .bind(to: hourText)
            .disposed(by: disposeBag)
    }

    func handlerMinuteTextField() {
        minuteTextFieldInRelay
            .map(setTimePickerMaxLength)
            .map {
                self.checkMinute($0) ? $0 : ""
            }
            .bind(to: minuteText)
            .disposed(by: disposeBag)
    }

    func setTimePickerMaxLength(_ hour: String) -> String {
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
