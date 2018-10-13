////
////  SwipeableCollectionViewCell.swift
////  DoorDash
////
////  Created by Marvin Zhan on 2018-10-11.
////  Copyright © 2018 Monster. All rights reserved.
////
//
//import UIKit
//import SnapKit
//
//private enum ActionLabelCurrentPos {
//    case left
//    case right
//}
//
//class SwipeableCollectionViewCell: UICollectionViewCell {
//
//    let swipeContainer: UIView
//    let contentContainer: UIView
//    let actionLabel: UILabel
//    var actionLabelCurrentFrame: CGRect = .zero
//    var swipeContainerCurrentFrame: CGRect
//    let swipeContainerExtraLeftSpace: CGFloat = 30
//    let actionLabelThreshold: CGFloat
//
//    var isGestureDisable: Bool = false
//    private var labelPos: ActionLabelCurrentPos = .right
//
//    override init(frame: CGRect) {
//        actionLabelThreshold = 1 / 5 * frame.width
//        let swipeContainerFrame = CGRect(x: -swipeContainerExtraLeftSpace, y: 0, width: frame.width + swipeContainerExtraLeftSpace, height: frame.height)
//        swipeContainer = UIView(frame: swipeContainerFrame)
//        contentContainer = UIView()
//        actionLabel = UILabel()
//        swipeContainerCurrentFrame = swipeContainerFrame
//        super.init(frame: frame)
//        setupUI()
//        setupActions()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.layoutIfNeeded()
//        actionLabelCurrentFrame = self.actionLabel.frame
//    }
//
//    func setupActions() {
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(respondToPanGesture(gesture:)))
//        self.contentContainer.addGestureRecognizer(panGesture)
//    }
//
//    @objc func respondToPanGesture(gesture: UIPanGestureRecognizer) {
//        let orginFrameWidth = swipeContainerCurrentFrame.width
//        let orginFrameHeight = swipeContainerCurrentFrame.height
//        let originFrameY = swipeContainerCurrentFrame.minY
//        if gesture.state == .began {
//
//        } else if gesture.state == .changed {
//            let translation = gesture.translation(in: self)
//            var extraMovement: CGFloat = 0
//            if translation.x > 0 {
//                extraMovement = contentContainer.frame.width / actionLabelThreshold
//            } else {
//                extraMovement = -contentContainer.frame.width / actionLabelThreshold
//            }
//            var newXPos: CGFloat = swipeContainerCurrentFrame.minX + translation.x + extraMovement
//            if self.swipeContainer.frame.maxX + translation.x > contentContainer.frame.maxX {
//                var adjustX = translation.x / swipeContainerExtraLeftSpace
//                if adjustX > swipeContainerExtraLeftSpace {
//                    adjustX = swipeContainerExtraLeftSpace
//                }
//                if self.swipeContainer.frame.minX + adjustX < -swipeContainerExtraLeftSpace {
//                    newXPos = self.swipeContainer.frame.minX + adjustX
//                } else {
//                    newXPos = -swipeContainerExtraLeftSpace + translation.x / swipeContainerExtraLeftSpace
//                }
//            }
//            self.swipeContainer.frame = CGRect(x: newXPos, y: originFrameY, width: orginFrameWidth, height: orginFrameHeight)
//            if self.swipeContainer.frame.maxX < self.contentContainer.frame.maxX {
//                var posX: CGFloat = actionLabelCurrentFrame.minX + translation.x + extraMovement
//                if posX < self.contentContainer.frame.width - actionLabelThreshold {
//                    posX = self.contentContainer.frame.width - actionLabelThreshold
//                }
//                actionLabel.frame = CGRect(x: posX, y: actionLabelCurrentFrame.minY, width: actionLabelCurrentFrame.width, height: actionLabelCurrentFrame.height)
//            }
//            if self.swipeContainer.frame.maxX < actionLabelThreshold {
//
//            } else {
//
//            }
//        } else if gesture.state == .ended {
//            var frameToAdjust: CGRect = .zero
//            var actionLabelFrameToAdjust: CGRect = actionLabelCurrentFrame
//            if swipeContainer.frame.maxX > contentContainer.frame.maxX - actionLabelThreshold
//                && swipeContainer.frame.maxX < contentContainer.frame.maxX {
//                frameToAdjust = CGRect(x: -swipeContainerExtraLeftSpace, y: originFrameY, width: orginFrameWidth, height: orginFrameHeight)
//                actionLabelFrameToAdjust = CGRect(x: self.contentContainer.frame.width, y: actionLabelCurrentFrame.minY, width: actionLabelCurrentFrame.width, height: actionLabelCurrentFrame.height)
//            } else if swipeContainer.frame.maxX > actionLabelThreshold
//                && swipeContainer.frame.maxX < contentContainer.frame.maxX {
//                frameToAdjust = CGRect(x: -self.actionLabelThreshold - swipeContainerExtraLeftSpace, y: originFrameY, width: orginFrameWidth, height: orginFrameHeight)
//                actionLabelFrameToAdjust = CGRect(
//                    x: self.contentContainer.frame.width - self.actionLabelThreshold,
//                    y: self.actionLabelCurrentFrame.minY,
//                    width: self.actionLabelCurrentFrame.width,
//                    height: self.actionLabelCurrentFrame.height
//                )
//            } else {
//                // trigger remove
//                actionLabelFrameToAdjust = CGRect(x: self.contentContainer.frame.width, y: actionLabelCurrentFrame.minY, width: actionLabelCurrentFrame.width, height: actionLabelCurrentFrame.height)
//                frameToAdjust = CGRect(x: -swipeContainerExtraLeftSpace, y: originFrameY, width: orginFrameWidth, height: orginFrameHeight)
//            }
//            if frameToAdjust != .zero {
//                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
//                    self.swipeContainer.frame = frameToAdjust
//                    self.actionLabel.frame = actionLabelFrameToAdjust
//                }, completion: { _ in
//                    self.swipeContainerCurrentFrame = self.swipeContainer.frame
//                    self.actionLabelCurrentFrame = self.actionLabel.frame
//                })
//            }
//        }
//    }
//
//    func setupUI() {
//        setupSwipeContainer()
//        setupContentContainer()
//        setupActionLabel()
//        setupConstraints()
//    }
//
//    func setupSwipeContainer() {
//        contentContainer.addSubview(swipeContainer)
//    }
//
//    func setupContentContainer() {
//        self.addSubview(contentContainer)
//    }
//
//    func setupActionLabel() {
//        contentContainer.addSubview(actionLabel)
//        actionLabel.numberOfLines = 1
//        actionLabel.text = "Delete"
//        actionLabel.textColor = ApplicationDependency.manager.theme.colors.white
//        actionLabel.font = ApplicationDependency.manager.theme.fontSchema.medium16
//        actionLabel.minimumScaleFactor = 0.5
//        actionLabel.textAlignment = .center
//    }
//
//    func setupConstraints() {
//        contentContainer.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
//
//        actionLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(contentContainer.snp.trailing)
//            make.width.equalTo(actionLabelThreshold)
//        }
//    }
//}
