//
//  ViewController.swift
//  marafon_step3
//
//  Created by Nikolay Volnikov on 07.05.2023.
//

import UIKit
import SnapKit
import Foundation

class ViewController: UIViewController {

    private var animator: UIViewPropertyAnimator!

    private lazy var rotateView: UIView = {
        let rotateView = UIView()
        rotateView.translatesAutoresizingMaskIntoConstraints = false
        rotateView.backgroundColor = .systemBlue
        rotateView.layer.cornerRadius = 10
        rotateView.layer.cornerCurve = .continuous
        return rotateView
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(self.sliderTouchCancel(_:)), for: .touchUpInside)
        return slider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rotateView)
        view.addSubview(slider)
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [weak self, rotateView] in
            rotateView.center.x = (self?.view.bounds.width ?? 0) - 50
            rotateView.transform = CGAffineTransform(rotationAngle: CGFloat((90 * CGFloat.pi) / 180)).scaledBy(x: 1.5, y: 1.5)
        }

        rotateView.snp.makeConstraints {
            $0.size.equalTo(50)
            $0.top.equalToSuperview().offset(100)
            $0.leadingMargin.trailingMargin.equalToSuperview()
        }

        slider.snp.makeConstraints {
            $0.leadingMargin.trailingMargin.equalToSuperview()
            $0.height.equalTo(40)
            $0.top.equalTo(rotateView.snp.bottom).offset(40)
        }

    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        animator.fractionComplete = CGFloat(sender.value)
    }

    @objc func sliderTouchCancel(_ sender: UISlider!) {
            if animator.isRunning {
                slider.value = Float(animator.fractionComplete)
            }
            slider.setValue(slider.maximumValue, animated: true)
            animator.pausesOnCompletion = true
            animator.startAnimation()
    }
}
