//
//  RatingSliderView.swift
//  DoorDash
//
//  Created by Marvin Zhan on 8/6/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol RatingSliderViewDelegate: class {
    func didUpdateToValue(_ value: String)
}

final class RatingSliderView: UIView {

    final class RatingDotView: UIView {

        let dot: UIView
        let constants = RatingSliderView.Constants()

        override init(frame: CGRect) {
            dot = UIView()
            super.init(frame: frame)
            backgroundColor = ApplicationDependency.manager.theme.colors.white
            addSubview(dot)
            dot.layer.cornerRadius = constants.pointDotSize / 2
            dot.backgroundColor = constants.dotBackgroundColor
            dot.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(constants.pointDotSize)
            }
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    struct Constants {
        let thumbViewSize: CGFloat = 28
        let pointDotSize: CGFloat = 6
        let dotContainerSize: CGFloat = 10
        let lineHeight: CGFloat = 2
        let spaceBetweenPointAndLine: CGFloat = 2
        let horizontalSpacing: CGFloat = 16
        let verticalSpacing: CGFloat = 4
        let spaceBetweenPointAndLabel: CGFloat = 20
        let dotBackgroundColor: UIColor = ApplicationDependency.manager.theme.colors.separatorGray
        let lineBackgroundColor: UIColor = ApplicationDependency.manager.theme.colors.gray
        let selectedColor: UIColor = ApplicationDependency.manager.theme.colors.black
        let normalColor: UIColor = ApplicationDependency.manager.theme.colors.gray
    }

    private let thumbView: UIView
    private let normalLine: UIView
    private let selectedLine: UIView
    private var dots: [RatingDotView] = []
    private var labels: [UILabel] = []
    private var currThumbViewTransform: CGAffineTransform = .identity
    private var lineWidth: CGFloat = 0
    private var dataValues: [String] = []
    private let constants = Constants()

    weak var delegate: RatingSliderViewDelegate?

    override init(frame: CGRect) {
        thumbView = UIView()
        normalLine = UIView()
        selectedLine = UIView()
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        thumbView.addShadow(
            size: CGSize(width: 1, height: 2),
            radius: constants.thumbViewSize / 2,
            shadowColor: ApplicationDependency.manager.theme.colors.doorDashRed.withAlphaComponent(0.1),
            shadowOpacity: 1,
            viewCornerRadius: constants.thumbViewSize / 2
        )
    }

    func clear() {
        subviews.forEach { $0.removeFromSuperview() }
        dots.removeAll()
        labels.removeAll()
    }

    func setupView(values: [String], defaultValue: String) {
        clear()
        dataValues = values
        let containerWidth = frame.width - 2 * constants.horizontalSpacing
        let numOfPoints = CGFloat(values.count)
        let totalLinesWidth = containerWidth - constants.pointDotSize * numOfPoints - 2 * constants.spaceBetweenPointAndLine * (numOfPoints - 1)
        lineWidth = totalLinesWidth / (numOfPoints - 1)
        let yCenter = constants.verticalSpacing + constants.dotContainerSize / 2
        var currX = constants.horizontalSpacing
        var selectedX: CGFloat = 0
        addSubview(normalLine)
        normalLine.frame = CGRect(
            x: constants.horizontalSpacing,
            y: yCenter - constants.lineHeight / 2,
            width: containerWidth,
            height: constants.lineHeight
        )
        addSubview(selectedLine)
        for (i, value) in values.enumerated() {
            let dot = generateDotContainer(currX: currX)
            addSubview(dot)
            dots.append(dot)
            if value == defaultValue {
                selectedX = currX
            }
            let label = generateValueLabel(text: value)
            addSubview(label)
            labels.append(label)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(dot.snp.bottom).offset(constants.spaceBetweenPointAndLabel)
                make.centerX.equalTo(dot)
            }
            currX += constants.pointDotSize + constants.spaceBetweenPointAndLine
            if i == values.count - 1 { break }
            currX += constants.spaceBetweenPointAndLine + lineWidth
        }
        addSubview(thumbView)
        layoutIfNeeded()
        updateThumbViewFrame(x: selectedX)
        updateSelectedLineFrame(x: selectedX + constants.dotContainerSize)
        updatePoints(currX: selectedX)
        updateLabels(currX: selectedX)
    }

    private func updatePoints(currX: CGFloat) {
        var playedImpact: Bool = false
        for dotContainer in dots {
            let prevColor = dotContainer.dot.backgroundColor
            dotContainer.dot.backgroundColor = dotContainer.frame.maxX > currX ? constants.selectedColor : constants.dotBackgroundColor
            if prevColor != dotContainer.dot.backgroundColor, !playedImpact {
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                playedImpact = true
            }
        }
    }

    private func updateLabels(currX: CGFloat) {
        for label in labels {
            label.textColor = label.frame.maxX > currX ? constants.selectedColor : constants.normalColor
        }
    }

    private func generateDotContainer(currX: CGFloat) -> RatingDotView {
        let dotFrame = CGRect(x: currX, y: constants.verticalSpacing, width: constants.dotContainerSize, height: constants.dotContainerSize)
        let dotContainer = RatingDotView(frame: dotFrame)
        return dotContainer
    }

    private func updateThumbViewFrame(x: CGFloat) {
        let centerX = x + constants.pointDotSize / 2
        let centerY = constants.verticalSpacing + constants.dotContainerSize / 2
        thumbView.frame = CGRect(
            x: centerX - constants.thumbViewSize / 2,
            y: centerY - constants.thumbViewSize / 2,
            width: constants.thumbViewSize,
            height: constants.thumbViewSize
        )
    }

    private func updateSelectedLineFrame(x: CGFloat) {
        let width = normalLine.frame.maxX - x
        selectedLine.frame = CGRect(x: x, y: normalLine.frame.minY, width: width, height: normalLine.frame.height)
    }

    private func findIndex(x: CGFloat) -> Int {
        var result = dots.count - 1
        for (i, dot) in dots.enumerated() {
            guard let nextDot = dots[safe: i + 1] else { break }
            if x >= dot.center.x, nextDot.frame.minX > x {
                if x > dot.frame.maxX + lineWidth / 2 {
                    result = i + 1
                } else {
                    result = i
                }
            }
        }
        return result
    }

    private func scrollTo(index: Int) {
        guard let dot = dots[safe: index] else { return }
        UIView.animate(withDuration: 0.2) {
            self.thumbView.center = dot.center
        }
        let updatePoint = dot.frame.minX
        updatePoints(currX: updatePoint)
        updateSelectedLineFrame(x: updatePoint)
        updateLabels(currX: updatePoint)
    }
}

extension RatingSliderView {

    private func setupUI() {
        setupThumbView()
        setupLines()
    }

    private func setupLines() {
        normalLine.backgroundColor = constants.lineBackgroundColor
        selectedLine.backgroundColor = constants.selectedColor
    }

    private func setupThumbView() {
        thumbView.backgroundColor = ApplicationDependency.manager.theme.colors.doorDashRed
        thumbView.layer.cornerRadius = constants.thumbViewSize / 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        thumbView.addGestureRecognizer(panGesture)
    }

    private func generateValueLabel(text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = constants.normalColor
        titleLabel.font = ApplicationDependency.manager.theme.fonts.medium16
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        return titleLabel
    }
}

extension RatingSliderView {

    @objc
    private func handlePan(_ panGesture: UIPanGestureRecognizer) {
        let point = panGesture.location(in: self)
        let leftMin = dots.first?.center.x ?? 0
        let rightMax = dots.last?.center.x ?? 0
        let posX = min(rightMax, max(leftMin, point.x))
        switch panGesture.state {
        case .changed:
            thumbView.center = CGPoint(x: posX, y: thumbView.center.y)
            let updatePoint = posX
            updatePoints(currX: updatePoint)
            updateSelectedLineFrame(x: updatePoint)
            updateLabels(currX: updatePoint)
        case .ended:
            let index = findIndex(x: posX)
            scrollTo(index: index)
            delegate?.didUpdateToValue(dataValues[safe: index] ?? "")
        default: break
        }
    }
}
