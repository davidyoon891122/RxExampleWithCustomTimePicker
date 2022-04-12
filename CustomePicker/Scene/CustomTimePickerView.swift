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

final class CustomTimePickerView: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blackView.addGestureRecognizer(tapGesture)
    }

    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
}
