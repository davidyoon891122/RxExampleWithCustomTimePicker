//
//  WriteViewController.swift
//  CustomePicker
//
//  Created by iMac on 2022/04/12.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WriteViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.green, for: .normal)
        return button
    }()

    private let separatorView = Separator()

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 입력"
        textField.font = .systemFont(ofSize: 18.0, weight: .bold)
        return textField
    }()

    private let titleSeparatorView = Separator()

    private lazy var timePickerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        [
            timeTitleLabel,
            openTimePickerbutton
        ]
            .forEach {
                stackView.addArrangedSubview($0)
            }
        return stackView
    }()

    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 시간"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        return label
    }()

    private lazy var openTimePickerbutton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .medium)
        button.setTitle("타임 피커", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    private let timePickerSeparator = Separator()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0, weight: .medium)
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.masksToBounds = true
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLayoutConstraint()
        bindUI()
    }
}

extension WriteViewController: CustomTimePickerViewProtocol {
    func sendDateInfo(date: String) {
        print(date)
        textView.text = date
    }
}
private extension WriteViewController {
    func addSubviews() {
        view.backgroundColor = .systemBackground
        [
            closeButton,
            completeButton,
            separatorView,
            titleTextField,
            titleSeparatorView,
            timePickerHStackView,
            timePickerSeparator,
            textView
        ]
            .forEach {
                view.addSubview($0)
            }
    }

    func setLayoutConstraint() {
        let inset: CGFloat = 16.0

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4.0)
            $0.leading.equalToSuperview().offset(4.0)
            $0.width.height.equalTo(50.0)
        }

        completeButton.snp.makeConstraints {
            $0.top.equalTo(closeButton)
            $0.trailing.equalToSuperview().offset(-4.0)
            $0.width.height.equalTo(closeButton)
        }

        separatorView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(4.0)
            $0.leading.trailing.equalToSuperview()
        }

        titleTextField.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
            $0.height.equalTo(70.0)
        }

        titleSeparatorView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
        }

        timePickerHStackView.snp.makeConstraints {
            $0.top.equalTo(titleSeparatorView.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
        }

        timePickerSeparator.snp.makeConstraints {
            $0.top.equalTo(timePickerHStackView.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(timePickerHStackView.snp.bottom).offset(inset)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-inset)
        }
    }

    func bindUI() {
        closeButton.rx.tap
            .asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        openTimePickerbutton.rx.tap
            .asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let customTimePickerView = CustomTimePickerView()
                customTimePickerView.delegate = self
                customTimePickerView.modalPresentationStyle = .fullScreen
                self.present(customTimePickerView, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
