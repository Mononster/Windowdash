import UIKit

extension UIAttachmentBehavior {

    static func shake(item: UIDynamicItem, anchor: CGPoint) -> UIAttachmentBehavior {
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: anchor)
        attachmentBehavior.damping = 0.1
        attachmentBehavior.frequency = 4.0
        return attachmentBehavior
    }
}
