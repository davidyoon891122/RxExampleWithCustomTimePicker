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
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Write", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()

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
            writeButton
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
    }
}

