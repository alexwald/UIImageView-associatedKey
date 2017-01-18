//
//  UIImageView+associatedKey.swift
//

import Foundation
import AlamofireImage

let activityViewTag = 888

extension UIImageView {
    
    private struct AssociatedKeys {
        static var AssociatedUrl = NSURL()
    }

    var activityIndicatorView: UIActivityIndicatorView {
        if let activityIndicatorView = subviews.filter({ $0.tag == activityViewTag }).first as? UIActivityIndicatorView {
            return activityIndicatorView
        }
        let activityIndicatorView = UIActivityIndicatorView(frame: self.bounds)
        activityIndicatorView.startAnimating()
        activityIndicatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        activityIndicatorView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        activityIndicatorView.tag = activityViewTag
        activityIndicatorView.hidesWhenStopped = true
        self.addSubview(activityIndicatorView)
        return activityIndicatorView
    }
    
    var associatedUrl: NSURL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.AssociatedUrl) as? NSURL
        }

        set {
            let placeHolder = UIImage(named: "default-placeholder")
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.AssociatedUrl,
                    newValue as NSURL?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                
                
                self.activityIndicatorView.startAnimating()
                
                self.image = nil
                
                self.af_setImageWithURL(
                    newValue,
                    placeholderImage: nil,
                    filter: nil,
                    imageTransition: .CrossDissolve(0.1),
                    completion: { response in
                        if self.associatedUrl == response.request?.URL {
                            self.activityIndicatorView.stopAnimating()
                            self.image = response.result.value
                        }
                    }
                )
            } else {
                self.image = placeHolder
            }
        }
    }
}
