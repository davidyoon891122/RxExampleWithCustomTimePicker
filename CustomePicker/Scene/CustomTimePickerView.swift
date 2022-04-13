//
//  CustomTimePickerView.swift
//  CustomPicker
//
//  Created by iMac on 2022/04/12.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol CustomTimePickerViewProtocol: AnyObject {
    func sendDateInfo(date: String)
}

final class CustomTimePickerView: UIViewController {
    private let disposeBag = DisposeBag()

    private let viewModel = CustomViewModel()

    private lazy var meridiemValue = meridiems[0]

    weak var delegate: CustomTimePickerViewProtocol?

    private lazy var blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.8
        return view
    }()

    private lazy var timePickerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.layer.cornerRadius = 14.0
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = CGSize(width: 10, height: 20)
        return view
    }()

    private let meridiems = ["AM", "PM"]

    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: meridiems)
        segment.selectedSegmentIndex = 0
        segment.addTarget(
            self,
            action: #selector(segmentControlValueChanged),
            for: .valueChanged
        )
        return segment
    }()

    private lazy var timeInputHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.distribution = .fillProportionally

        [
            hourTextField,
            commaLabel,
            minuteTextField
        ]
            .forEach {
                stackView.addArrangedSubview($0)
            }
        return stackView
    }()

    private lazy var hourTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "00"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var commaLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        return label
    }()

    private lazy var minuteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "00"
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindUI()
        setupTapGesture()
    }
}

private extension CustomTimePickerView {
    func setupViews() {
        view.backgroundColor = .systemBackground
        [
            blackView,
            timePickerView
        ]
            .forEach {
                view.addSubview($0)
            }
        blackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        timePickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(200.0)
        }

        [
            segmentControl,
            timeInputHStackView,
            completeButton
        ]
            .forEach {
                timePickerView.addSubview($0)
            }

        let inset: CGFloat = 16.0

        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        timeInputHStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150.0)
            $0.height.equalTo(65.0)
        }

        completeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-inset)
            $0.bottom.equalToSuperview().offset(-inset)
        }
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blackView.addGestureRecognizer(tapGesture)

        let dismissKeyboardTapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        timePickerView.addGestureRecognizer(dismissKeyboardTapGesture)
    }

    func bindUI() {
        hourTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputs.hourTextFieldInRelay)
            .disposed(by: disposeBag)

        viewModel.handleHourTextField()

        viewModel.hourText
            .bind(to: hourTextField.rx.text)
            .disposed(by: disposeBag)

        minuteTextField.rx.text
            .orEmpty
            .bind(to: viewModel.inputs.minuteTextFieldInRelay)
            .disposed(by: disposeBag)

        viewModel.handlerMinuteTextField()

        viewModel.minuteText
            .bind(to: minuteTextField.rx.text)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .subscribe(onNext: {
                guard let hour = self.hourTextField.text else { return }
                guard let minute = self.minuteTextField.text else { return }
                if hour == "" || minute == "" {
                    let alert = UIAlertController(
                        title: "에러",
                        message: "Shouldn't be Null",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(
                        title: "완료",
                        style: .cancel,
                        handler: nil)
                    )
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.delegate?.sendDateInfo(date: self.meridiemValue + " " + hour + minute)
                    self.dismiss(animated: false, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }

    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }

    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        meridiemValue = meridiems[sender.selectedSegmentIndex]
    }
}
