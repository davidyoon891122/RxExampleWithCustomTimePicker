//
//  ViewController.swift
//  CustomePicker
//
//  Created by iMac on 2022/04/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    let testView = UIView()
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()

    private lazy var openScrollPopupButton: UIButton = {
        let button = UIButton()
        button.setTitle("ScrollPopup", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()

    private var blackView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindUI()
    }
}

private extension ViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        [
            writeButton,
            openScrollPopupButton
        ]
            .forEach {
                view.addSubview($0)
            }

        writeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60.0)
            $0.height.equalTo(50.0)
        }

        openScrollPopupButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
            $0.leading.equalToSuperview().offset(16.0)
            $0.width.equalTo(80.0)
            $0.height.equalTo(50.0)
        }
    }

    func bindUI() {
        writeButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: print("return"))
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let writeVC = WriteViewController()
                self.present(writeVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        openScrollPopupButton.rx.tap
            .asDriver()
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.openWindowView()
                print("Test")
            })
            .disposed(by: disposeBag)
    }

    func openWindowView() {
        blackView.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        let windowScenes = UIApplication.shared.connectedScenes
            .first as? UIWindowScene

        guard let window = windowScenes?.windows.first else { return }

        blackView.frame = window.frame
        blackView.alpha = 0

        blackView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(didTapBlackView)
            )
        )

        testView.backgroundColor = .systemBackground

        [
            blackView,
            testView
        ]
            .forEach {
                window.addSubview($0)
            }

        let height: CGFloat = 500.0
        let testViewYOffset = window.frame.height - height

        testView.frame = CGRect(
            x: 0,
            y: window.frame.height,
            width: window.frame.width,
            height: height
        )

        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.blackView.alpha = 1
                self.testView.frame = CGRect(
                    x: 0,
                    y: testViewYOffset,
                    width: window.frame.width,
                    height: height
                )
            }, completion: nil)
    }

    @objc func didTapBlackView() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseInOut,
            animations: {
                self.blackView.alpha = 0

                let windowScenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
                guard let window = windowScenes?.windows.first else { return }

                self.testView.frame = CGRect(
                    x: 0,
                    y: window.frame.height,
                    width: self.testView.frame.width,
                    height: self.testView.frame.height
                )
            },
            completion: nil
        )
    }
}
