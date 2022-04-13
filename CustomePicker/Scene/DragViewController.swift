//
//  DragViewController.swift
//  CustomePicker
//
//  Created by iMac on 2022/04/13.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DragViewController: UIViewController {
    private lazy var blackView: UIView = {
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return blackView
    }()

    private lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .systemBackground
        bottomView.layer.cornerRadius = 14.0
        bottomView.layer.masksToBounds = true
        return bottomView
    }()

    private lazy var applyButton: UIButton = {
        let button = UIButton()

        button.setTitle("적용", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGestures()
    }
}

private extension DragViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        [
            blackView,
            bottomView
        ]
            .forEach {
                view.addSubview($0)
            }
        blackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(350.0)
            $0.bottom.equalToSuperview()
        }

    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBlackView))
        blackView.addGestureRecognizer(tapGesture)
    }

    @objc func didTapBlackView() {
        dismiss(animated: false, completion: nil)
    }
}
