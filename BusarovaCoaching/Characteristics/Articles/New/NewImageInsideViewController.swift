//
//  NewImageInsideViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 14/09/2018.
//  Copyright © 2018 The Homber Team. All rights reserved.
//

import UIKit
import Kingfisher

class NewImageInsideViewController: UIViewController, ArticleInsideElementsProtocol {
    private var articleInside: ArticleInside? = nil
    private var isSaved: Bool = false
    private var sequence: Int? = nil
    private var articleSaveDelegate: ArticleSaveDelegateProtocol?
    
    private var imagePickerController = UIImagePickerController()
    
    lazy private var captionTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = " Заголовок изображения. Необязательный"
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.leftViewMode = UITextField.ViewMode.always
        
        return textField
    }()
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        return imageView
    }()
    
    func configure(with articleInside: ArticleInside?, as sequence: Int, delegate: ArticleSaveDelegateProtocol) {
        self.articleInside = articleInside
        self.sequence = sequence
        self.articleSaveDelegate = delegate
        
        self.captionTextField.text = articleInside?.caption
        
        guard
            let articleInside = articleInside,
            let imageURL = articleInside.imageURL else {
            return
        }
        
        imageView.backgroundColor = UIColor.white
        imageView.kf.setImage(with: imageURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Изображение"
        
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveImage(sender:)))
        saveBarButtonItem.isEnabled = !isSaved
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        view.addSubview(captionTextField)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            captionTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            captionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: captionTextField.trailingAnchor, constant: 8),
            captionTextField.heightAnchor.constraint(equalToConstant: 30),
            
            imageView.topAnchor.constraint(equalTo: captionTextField.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
            ])
    }
}

// MARK: - saving data
extension NewImageInsideViewController {
    @objc
    private func saveImage(sender: UIBarButtonItem) {
        guard
            let sequence = sequence,
            let image = imageView.image else {
            return
        }
        
        let articleInsideID: String?
        let imageName: String
        if articleInside == nil {
            articleInsideID = nil
            imageName = UUID().uuidString
        } else {
            articleInsideID = articleInside!.id
            imageName = articleInside!.imageName!
        }
        
        FirebaseController.shared.getStorageController().uploadImage(image, with: imageName, to: StoragePath.characteristicsArticlesImages) {
            result in
            
            switch result {
            case .success(let url):
                let elementToSave = ArticleInside(id: self.articleInside?.id ?? "",
                                                  parentID: self.articleInside?.parentID ?? "",
                                                  sequence: sequence,
                                                  type: ArticleInsideType.image,
                                                  caption: self.captionTextField.text,
                                                  text: nil,
                                                  imageURL: url,
                                                  imageName: imageName,
                                                  numericList: nil,
                                                  listElements: nil
                                                    )
                self.articleSaveDelegate?.saveArticle(articleInside: elementToSave, with: articleInsideID)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                let alertDialog = AlertDialog(title: nil, message: error.getError())
                alertDialog.showAlert(in: self, completion: nil)
            }
        }
    }
}

// MARK: - ImagePickerController Delegate + NavigationController Delegate
extension NewImageInsideViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }
        
        imageView.backgroundColor = UIColor.white
        imageView.image = image
        
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - GestureRecognizer Delegate
extension NewImageInsideViewController: UIGestureRecognizerDelegate {
    @objc
    private func tapGestureRecognizer(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            if recognizer.wasTapInside(self.imageView) {
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
