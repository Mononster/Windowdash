//
//  SignupAgreementSectionController.swift
//  DoorDash
//
//  Created by Marvin Zhan on 2018-09-18.
//  Copyright © 2018 Monster. All rights reserved.
//

import IGListKit

final class SignupAgreementModel: NSObject, ListDiffable {

    var text: NSAttributedString?

    override init() {
        super.init()
        configureText()
    }

    func configureText() {
        let linkStyle = Style("link", {
            $0.font = FontAttribute(font: ApplicationDependency.manager.theme.fonts.agreementLabelFont)
            $0.color = ApplicationDependency.manager.theme.colors.linkTextColor
            $0.underline = UnderlineAttribute.init(
                color: ApplicationDependency.manager.theme.colors.linkTextColor,
                style: .single)
            $0.align = .left
        })

        let regular = Style("regular", {
            $0.font = FontAttribute(font: ApplicationDependency.manager.theme.fonts.agreementLabelFont)
            $0.color = ApplicationDependency.manager.theme.colors.gray
            $0.align = .left
        })

        let paragraph = Style("paragrah", {
            $0.minimumLineHeight = 1.5
            $0.lineSpacing = 1.5
            $0.align = .left
        })

        let descriptionText = "By tapping Sign up, Continue with Facebook, or Continue with Google you agree to our ".set(style: regular)
        let termsAndConditionsText = "Terms and Conditions".set(style: linkStyle)
        let privacyStatementText = "Privacy Statement".set(style: linkStyle)
        self.text = (descriptionText + termsAndConditionsText + " and ".set(style: regular) + privacyStatementText + ".".set(style: regular)).add(style: paragraph)
    }

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

final class SignupAgreementSectionController: ListSectionController {

    private var model: SignupAgreementModel?

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext?.containerSize.width ?? 0,
                      height: SignupAgreementCell.height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SignupAgreementCell.self, for: self, at: index) as? SignupAgreementCell, let text = model?.text else {
            fatalError()
        }
        cell.configureCell(text: text)
        return cell
    }

    override func didUpdate(to object: Any) {
        model = object as? SignupAgreementModel
    }
}
