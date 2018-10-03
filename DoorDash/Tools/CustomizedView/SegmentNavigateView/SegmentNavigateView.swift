//
//  SegmentNavigateView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-24.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SnapKit

final class SegmentNavigateView: UIScrollView {

    let titleColor: UIColor = ApplicationDependency.manager.theme.colors.darkGray
    let titleFont: UIFont = ApplicationDependency.manager.theme.fontSchema.medium16
    let titleSelectedFont: UIFont = ApplicationDependency.manager.theme.fontSchema.bold16
    let titleSelectedColor: UIColor = ApplicationDependency.manager.theme.colors.doorDashRed
    let sliderViewHeight: CGFloat = 4
    var currentIndex: Int = 0

    private var buttonWidthDict: [Int: CGFloat] = [:]
    private let viewHeight: CGFloat
    private let slider: UIView
    private let separator: Separator
    private var selectedButton: UIButton?
    private var allButtons: [UIButton] = []
    private var titles: [String] = []

    override init(frame: CGRect) {
        self.slider = UIView()
        self.viewHeight = frame.height
        self.separator = Separator.create()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitles(titles: [String]) {
        self.titles = titles
        self.setupButtons()
        self.layoutIfNeeded()
    }

    @objc
    func titleButtonSelected(sender: UIButton!) {
        adjustUI(currButton: sender, index: sender.tag)
    }

    func adjustUI(currButton: UIButton, index: Int) {
        self.selectedButton?.isSelected = false
        currButton.isSelected = true
        currButton.titleLabel?.font = titleSelectedFont
        self.selectedButton?.titleLabel?.font = titleFont
        let sliderWidth = self.buttonWidthDict[currButton.tag] ?? 0
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            let frame = self.slider.frame
            self.slider.frame = CGRect(
                x: frame.minX, y: frame.minY,
                width: sliderWidth, height: frame.height
            )
            self.slider.center.x = currButton.center.x
        })
        self.currentIndex = index
        self.selectedButton = currButton
        var offsetX = currButton.frame.origin.x - 10
        if offsetX > self.contentSize.width - self.frame.size.width {
            offsetX = self.contentSize.width - self.frame.size.width
        }
        if offsetX < 0 || self.contentSize.width <= self.frame.size.width {
            offsetX = 0
        }
        self.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    func scrollTo(index buttonTag: Int) {
        guard buttonTag != currentIndex else {
            return
        }
        adjustUI(currButton: allButtons[buttonTag], index: buttonTag)
    }
}

extension SegmentNavigateView {

    private func setupUI() {
        setupScrollViewProperties()
        setupSeparator()
        setupSlider()
    }

    private func setupSeparator() {
        self.addSubview(separator)
        separator.backgroundColor = ApplicationDependency.manager.theme.colors.separatorGray.withAlphaComponent(0.7)
    }

    private func setupScrollViewProperties() {
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }

    private func setupSlider() {
        self.addSubview(slider)
        slider.frame = CGRect(
            x: 0, y: viewHeight - sliderViewHeight,
            width: 0, height: sliderViewHeight
        )
        slider.backgroundColor = titleSelectedColor
        slider.layer.cornerRadius = 2
    }

    private func setupButtons() {
        var totalWidth: CGFloat = 15
        let buttonSpace: CGFloat = 15
        let maxTitleWidth: CGFloat = self.frame.width / 2
        for (i, title) in titles.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = i
            let titleWidth = titleSelectedFont.sizeOfString(
                string: title,
                constrainedToSize: CGSize(width: maxTitleWidth, height: viewHeight - 2)
            ).width
            self.buttonWidthDict[button.tag] = titleWidth
            self.addSubview(button)
            let buttonWidth: CGFloat = titleWidth + 10.0
            button.frame = CGRect(
                x: totalWidth, y: 0.5,
                width: buttonWidth, height: viewHeight - 2 - 0.5
            )
            configureButton(title: title, button: button)
            totalWidth = totalWidth + buttonWidth + buttonSpace
            if i == 0 {
                button.isSelected = true
                self.selectedButton = button
                self.slider.frame = CGRect(
                    x: self.slider.frame.minX,
                    y: self.slider.frame.minY,
                    width: titleWidth,
                    height: self.slider.frame.height
                )
                self.slider.center.x = button.center.x
            }
            allButtons.append(button)
        }
        totalWidth = totalWidth + buttonSpace
        separator.frame = CGRect(
            x: 0, y: viewHeight - sliderViewHeight / 2 - 0.2,
            width: max(self.frame.width, totalWidth), height: 0.4
        )
        var containerWidth = totalWidth
        if totalWidth < self.frame.width {
            containerWidth = self.frame.width
        }
        let container = UIView(frame: CGRect(
            x: 0, y: 0,
            width: containerWidth, height: viewHeight - 2 - 0.5)
        )
        container.backgroundColor = ApplicationDependency.manager.theme.colors.white
        self.addSubview(container)
        for button in allButtons {
            self.bringSubviewToFront(button)
        }
        self.bringSubviewToFront(slider)
        self.contentSize = CGSize(width: totalWidth, height: 0)
    }

    private func configureButton(title: String, button: UIButton) {
        button.contentMode = .center
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleSelectedColor, for: .selected)
        button.titleLabel?.font = titleFont
        button.addTarget(self, action: #selector(titleButtonSelected), for: .touchUpInside)
    }
}
