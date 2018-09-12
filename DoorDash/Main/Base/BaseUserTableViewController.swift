//
//  BaseTableViewController.swift
//  UWLife
//
//  Created by Marvin Zhan on 2018-03-04.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Photos

class BaseUserTableViewController: BaseViewController {

    let tableView: UITableView
    let imagePicker: UIImagePickerController

    override init() {
        tableView = UITableView()
        imagePicker = UIImagePickerController()
        super.init()
    }

    func uploadUserProfileImage(image: UIImage) {

    }

    func checkPermission(completion: @escaping (Bool) -> ()) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            log.info("Access is granted by user")
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                log.info("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    log.info("success")
                    completion(true)
                } else {
                    completion(false)
                }
            })
        case .restricted:
            log.info("User do not have access to photo album.")
            completion(false)
        case .denied:
            log.info("User has denied the permission.")
            completion(false)
        }
    }
}

extension BaseUserTableViewController {

    func registerCells(){
        self.tableView.register(nib: UINib(nibName: "ProfileCategoryViewCell", bundle: nil),
                                withCellClass: ProfileCategoryViewCell.self)
        self.tableView.register(nib: UINib(nibName: "UserProfileViewCell", bundle: nil),
                                withCellClass: UserProfileViewCell.self)
        self.tableView.register(nib: UINib(nibName: "UserNotLoggedinTableViewCell", bundle: nil),
                                withCellClass: UserNotLoggedinTableViewCell.self)
//        self.tableView.register(UINib.init(nibName: "EditProfileDetailViewCell", bundle: nil), forCellReuseIdentifier: "EditProfileDetailViewCell")
    }

    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = self.theme.colors.tableViewBackgroundColor
        registerCells()
    }
}

extension BaseUserTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != tableView.numberOfSections - 1 {
            return 10
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        if section != tableView.numberOfSections - 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
            view.layer.borderColor = theme.colors.lightSeparatorColor.lighten().cgColor
            view.layer.borderWidth = 1
            view.backgroundColor = theme.colors.tableViewBackgroundColor
            return view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
}

extension BaseUserTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BaseUserTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showPhotoPicker(){
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        // change the style sheet text color
        alert.view.tintColor = UIColor.black
        let actionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "Take a photo", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let actionPhoto = UIAlertAction.init(title: "Choose from photo library", style: .default) { (UIAlertAction) -> Void in
            self.selectFromPhoto()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        self.present(alert, animated: true, completion: nil)
    }

    func selectFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            // TODO: Handle Error
        }
    }

    func selectFromPhoto(){
        UIApplication.shared.statusBarStyle = .default
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            uploadUserProfileImage(image: image)
        } else {
            // TODO: Handle Error
        }
        dismiss(animated:true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

