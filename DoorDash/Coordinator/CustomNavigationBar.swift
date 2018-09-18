import UIKit

fileprivate let WRDefaultTitleSize:CGFloat = 18
fileprivate let WRDefaultTitleColor = UIColor.black
fileprivate let WRDefaultBackgroundColor = UIColor.white
fileprivate let kScreenWidth = UIScreen.main.bounds.size.width

enum NavigationBarStyle {
    case transparent
    case white
    case mainTheme
}

class CustomNavigationBar: UIView {

    var onClickLeftButton: (() -> ())?
    var onClickRightButton: (() -> ())?

    var title: String? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.text = newValue
        }
    }

    var attributedTitle: NSMutableAttributedString? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.attributedText = newValue
        }
    }

    var titleLabelColor: UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }

    var titleLabelFont: UIFont? {
        willSet {
            titleLabel.font = newValue
        }
    }

    var barBackgroundColor: UIColor? {
        willSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = newValue
        }
    }

    var barBackgroundImage: UIImage? {
        willSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = newValue
        }
    }

    var style: NavigationBarStyle = .mainTheme

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        //label.textColor = WRDefaultTitleColor
        label.font = UIFont.systemFont(ofSize: WRDefaultTitleSize)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()

    class func createBar() -> CustomNavigationBar {
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: ApplicationDependency.manager.theme.navigationBarHeight)
        return CustomNavigationBar(frame: frame)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(leftButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(bottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        backgroundView.backgroundColor = WRDefaultBackgroundColor
    }

    func updateFrame() {
        let top: CGFloat = UIDevice.current.hasNotch ? 44 : 20
        let margin: CGFloat = 0
        let buttonHeight: CGFloat = 44
        let buttonWidth: CGFloat = 44
        let titleLabelHeight: CGFloat = 44
        let titleLabelWidth: CGFloat = 180
        
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        leftButton.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: kScreenWidth - buttonWidth - margin, y: top, width: buttonWidth, height: buttonHeight)
        titleLabel.frame = CGRect(x: (kScreenWidth - titleLabelWidth) / 2.0, y: top, width: titleLabelWidth, height: titleLabelHeight)
        bottomLine.frame = CGRect(x: 0, y: bounds.height-0.5, width: kScreenWidth, height: 0.5)
    }
}

extension CustomNavigationBar {

    func setNavigationBarStyle(style: NavigationBarStyle, animated: Bool, titleColor: UIColor? = nil) {
        guard self.style != style else {
            return
        }
        self.style = style
        var alpha: CGFloat
        var tintColor: UIColor
        switch style {
        case .mainTheme:
            alpha = 1
            tintColor = ApplicationDependency.manager.theme.colors.doorDashRed
        case .transparent:
            alpha = 0
            tintColor = ApplicationDependency.manager.theme.colors.white
        case .white:
            alpha = 1
            tintColor = ApplicationDependency.manager.theme.colors.black
        }

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.setBackgroundAlpha(alpha: alpha)
                self.setTintColor(color: tintColor)
                self.titleLabel.alpha = alpha
            }, completion: nil)
        } else {
            setBackgroundAlpha(alpha: alpha)
            setTintColor(color: tintColor)
            self.titleLabel.alpha = alpha
        }
    }

    func setBottomLineHidden(hidden: Bool) {
        bottomLine.isHidden = hidden
    }

    func setBackgroundAlpha(alpha: CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
        bottomLine.alpha = alpha
    }

    func setTintColor(color: UIColor) {
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
    }

    func setLeftButton(normal: UIImage, highlighted: UIImage) {
        setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }

    func setLeftButton(image: UIImage) {
        setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }

    func setLeftButton(title: String, titleColor: UIColor) {
        setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    func setRightButton(normal: UIImage, highlighted: UIImage) {
        setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }

    func setRightButton(image: UIImage) {
        setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }

    func setRightButton(title: String, titleColor: UIColor) {
        setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }

    private func setLeftButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        leftButton.isHidden = false
        leftButton.setImage(normal, for: .normal)
        leftButton.setImage(highlighted, for: .highlighted)
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(titleColor, for: .normal)
    }

    private func setRightButton(normal: UIImage?, highlighted: UIImage?, title: String?, titleColor: UIColor?) {
        rightButton.isHidden = false
        rightButton.setImage(normal, for: .normal)
        rightButton.setImage(highlighted, for: .highlighted)
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
    }
}


// MARK: - 导航栏左右按钮事件
extension CustomNavigationBar {
    @objc func clickBack() {
        if let onClickBack = onClickLeftButton {
            onClickBack()
        } else {
            let currentVC = UIViewController.currentViewController()
            currentVC.toLastViewController(animated: true)
        }
    }
    @objc func clickRight() {
        if let onClickRight = onClickRightButton {
            onClickRight()
        }
    }
}

extension UIViewController {
    func toLastViewController(animated: Bool) {
        if self.navigationController != nil {
            if self.navigationController?.viewControllers.count == 1 {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        } else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }

    class func currentViewController() -> UIViewController {
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            return self.currentViewController(from: rootVC)
        } else {
            return UIViewController()
        }
    }

    class func currentViewController(from fromVC: UIViewController) -> UIViewController {
        if fromVC.isKind(of: UINavigationController.self) {
            let navigationController = fromVC as! UINavigationController
            return currentViewController(from: navigationController.viewControllers.last!)
        } else if fromVC.isKind(of: UITabBarController.self) {
            let tabBarController = fromVC as! UITabBarController
            return currentViewController(from: tabBarController.selectedViewController!)
        } else if fromVC.presentedViewController != nil {
            return currentViewController(from: fromVC.presentingViewController!)
        } else {
            return fromVC
        }
    }
}
