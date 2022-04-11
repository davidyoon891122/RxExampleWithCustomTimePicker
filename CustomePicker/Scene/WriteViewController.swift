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

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 입력"
        textField.font = .systemFont(ofSize: 14.0, weight: .medium)
        return textField
    }()

    private lazy var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시작 시간"
        label.textColor = .label
        label.font = .systemFont(ofSize: 12.0, weight: .medium)
        return label
    }()

    private lazy var openTimePickerbutton: UIButton = {
        let button = UIButton()
        button.setTitle("타임 피커", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

private extension WriteViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        [
            closeButton,
            completeButton,
            titleTextField,
            timeTitleLabel,
            openTimePickerbutton
        ]
            .forEach {
                view.addSubview($0)
            }

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



    }
}
