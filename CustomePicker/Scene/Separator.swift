//
//  Separator.swift
//  CustomePicker
//
//  Created by iMac on 2022/04/12.
//

import Foundation
import UIKit
import SnapKit

class Separator: UIView {
    private let separator = UIView()

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Separator {
    func setupViews() {
        addSubview(separator)

        separator.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
