//
//  UIColor+Gradient+Hex.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-12.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

public enum GradientDirection {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
    case topLeftToBottomRight
    case topRightToBottomLeft
    case bottomLeftToTopRight
    case bottomRightToTopLeft
}

open class GradientLayer: CAGradientLayer {

    private var direction: GradientDirection = .bottomLeftToTopRight

    public init(direction: GradientDirection, colors: [UIColor], cornerRadius: CGFloat = 0) {
        super.init()
        self.direction = direction
        self.needsDisplayOnBoundsChange = true
        self.colors = colors.map { $0.cgColor as Any }
        let (startPoint, endPoint) = GradientKitHelper.getStartEndPointOf(direction)
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius
    }

    public override init(layer: Any) {
        super.init(layer: layer)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init()
    }

    public final func clone() -> GradientLayer {
        if let colors = self.colors {
            return GradientLayer(direction: self.direction, colors: colors.map { UIColor.init(cgColor: $0 as! CGColor) }, cornerRadius: self.cornerRadius)
        }
        return GradientLayer(direction: self.direction, colors: [], cornerRadius: self.cornerRadius)
    }
}

public extension GradientLayer {
    static var oceanBlue: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight, colors: [UIColor.hex("2E3192"), UIColor.hex("1BFFFF")])
    }

    static var sanguine: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("D4145A"), UIColor.hex("FBB03B")])
    }

    static var lusciousLime: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("009245"), UIColor.hex("FCEE21")])
    }

    static var purpleLake: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("662D8C"), UIColor.hex("ED1E79")])
    }

    static var freshPapaya: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("ED1C24"), UIColor.hex("FCEE21")])
    }

    static var ultramarine: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("00A8C5"), UIColor.hex("FFFF7E")])
    }

    static var pinkSugar: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("D74177"), UIColor.hex("FFE98A")])
    }

    static var lemonDrizzle: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("FB872B"), UIColor.hex("D9E021")])
    }

    static var victoriaPurple: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("312A6C"), UIColor.hex("852D91")])
    }

    static var springGreens: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("009E00"), UIColor.hex("FFFF96")])
    }

    static var mysticMauve: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("B066FE"), UIColor.hex("63E2FF")])
    }

    static var reflexSilver: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("808080"), UIColor.hex("E6E6E6")])
    }

    static var neonGlow: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("00FFA1"), UIColor.hex("00FFFF")])
    }

    static var berrySmoothie: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("8E78FF"), UIColor.hex("FC7D7B")])
    }

    static var newLeaf: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("00537E"), UIColor.hex("3AA17E")])
    }

    static var cottonCandy: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("FCA5F1"), UIColor.hex("B5FFFF")])
    }

    static var pixieDust: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("D585FF"), UIColor.hex("00FFEE")])
    }

    static var fizzyPeach: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("F24645"), UIColor.hex("EBC08D")])
    }

    static var sweetDream: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("3A3897"), UIColor.hex("A3A1FF")])
    }

    static var firebrick: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("45145A"), UIColor.hex("FF5300")])
    }

    static var wroughtIron: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("333333"), UIColor.hex("5A5454")])
    }

    static var deepSea: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("4F00BC"), UIColor.hex("29ABE2")])
    }

    static var coastalBreeze: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("00B7FF"), UIColor.hex("FFFFC7")])
    }

    static var eveningDelight: GradientLayer {
        return GradientLayer(direction: .bottomLeftToTopRight , colors: [UIColor.hex("93278F"), UIColor.hex("00A99D")])
    }

    static var midnightCity: GradientLayer {
        return GradientLayer(direction: .leftToRight, colors: [UIColor.hex("232526"), UIColor.hex("414345")])
    }
}

open class GradientKitHelper {
    public static func getStartEndPointOf(_ gradientDirection: GradientDirection) -> (startPoint: CGPoint, endPoint: CGPoint) {
        switch gradientDirection {
        case .topToBottom:
            return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
        case .bottomToTop:
            return (CGPoint(x: 0.5, y: 1.0), CGPoint(x: 0.5, y: 0.0))
        case .leftToRight:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .rightToLeft:
            return (CGPoint(x: 1.0, y: 0.5), CGPoint(x: 0.0, y: 0.5))
        case .topLeftToBottomRight:
            return (CGPoint.zero, CGPoint(x: 1.0, y: 1.0))
        case .topRightToBottomLeft:
            return (CGPoint(x: 1.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        case .bottomLeftToTopRight:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .bottomRightToTopLeft:
            return (CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 0.0))
        }
    }
}


public extension UIView {

    func addGradientWithDirection(_ direction: GradientDirection, colors: [UIColor], cornerRadius: CGFloat = 0) {
        let gradientLayer = GradientLayer(direction: direction, colors: colors, cornerRadius: cornerRadius)
        self.addGradient(gradientLayer)
    }

    func addGradient(_ gradientLayer: GradientLayer, cornerRadius: CGFloat = 0) {
        let cloneGradient = gradientLayer.clone()
        cloneGradient.frame = self.bounds
        cloneGradient.cornerRadius = cornerRadius
        self.layer.addSublayer(cloneGradient)
    }
}

public extension UIColor {

    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        guard let hex = Int(hex, radix: 16) else { return UIColor.clear }
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hex & 0x00FF00) >> 8)) / 255.0,
                       blue: ((CGFloat)((hex & 0x0000FF) >> 0)) / 255.0,
                       alpha: alpha)
    }

    static func fromGradient(_ gradient: GradientLayer, frame: CGRect, cornerRadius: CGFloat = 0) -> UIColor? {
        guard let image = UIImage.fromGradient(gradient, frame: frame, cornerRadius: cornerRadius) else { return nil }
        return UIColor(patternImage: image)
    }

    static func fromGradientWithDirection(_ direction: GradientDirection, frame: CGRect, colors: [UIColor], cornerRadius: CGFloat = 0) -> UIColor? {
        let gradient = GradientLayer(direction: direction, colors: colors, cornerRadius: cornerRadius)
        return UIColor.fromGradient(gradient, frame: frame)
    }
}

public extension UIImage {

    static func fromGradient(_ gradient: GradientLayer, frame: CGRect, cornerRadius: CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let cloneGradient = gradient.clone()
        cloneGradient.frame = frame
        cloneGradient.cornerRadius = cornerRadius
        cloneGradient.render(in: ctx)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }

    static func fromGradientWithDirection(_ direction: GradientDirection, frame: CGRect, colors: [UIColor], cornerRadius: CGFloat = 0) -> UIImage? {
        let gradient = GradientLayer(direction: direction, colors: colors, cornerRadius: cornerRadius)
        return UIImage.fromGradient(gradient, frame: frame)
    }
}
