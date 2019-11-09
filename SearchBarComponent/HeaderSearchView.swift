//
//  HeaderSearchView.swift
//  SearchBarComponent
//
//  Created by Alexandr on 09.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

class HeaderSearchView: UIView {
    
    @IBOutlet weak var clearSearchQueryButton: UIButton!
    @IBOutlet weak var navigationChainLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    private var searchButton: UIButton!
    private var auxiliaryLabel: UILabel!
    
    @IBOutlet weak var queryTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var searchQueryTextFieldRightConstraint: NSLayoutConstraint!
    private weak var heightFromSuperviewConstraint: NSLayoutConstraint!
    
    lazy private var anim: UIViewPropertyAnimator = UIViewPropertyAnimator(
        duration: 0.25,
        timingParameters: UISpringTimingParameters()
    )
    
    @IBOutlet weak var searchQueryTextField: UITextField! {
        didSet {
            self.searchQueryTextField.layer.borderWidth = 1.0
            self.searchQueryTextField.layer.borderColor = UIColor.blue.cgColor
            self.searchQueryTextField.layer.cornerRadius = 8
            self.searchQueryTextField.addTarget(self, action: #selector(expand), for: .touchDown)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
        
        if heightFromSuperviewConstraint == nil {
            self.constraints.forEach { (constraint) in
                if constraint.firstAnchor == heightAnchor {
                    self.heightFromSuperviewConstraint = constraint
                }
            }
        }
        
        if auxiliaryLabel == nil {
            addAuxiliaryLabelForQueryTextField()
        }
    }
    
    @IBAction func clearSearchQueryButtonWasTapped(_ sender: UIButton) {
        searchQueryTextField.text?.removeAll()
        searchQueryTextField.resignFirstResponder()
    }
    
}

//MARK: - Initializers
extension HeaderSearchView {
    
    private func setUp() {
        setUpViewFromNib()
    
        searchButton = UIButton(type: .roundedRect)
        
        addSearchButtonToTextField()
    }
    
    private func setUpViewFromNib() {
        Bundle.main.loadNibNamed("HeaderSearchView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func addAuxiliaryLabelForQueryTextField() {
        auxiliaryLabel = UILabel()
        auxiliaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(auxiliaryLabel)

        auxiliaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        auxiliaryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        
        auxiliaryLabel.font = auxiliaryLabel.font.withSize(14)
        auxiliaryLabel.alpha = 0
        print(searchQueryTextField.frame, auxiliaryLabel.frame)
    }
    
    private func addSearchButtonToTextField() {
        searchQueryTextField.leftViewMode = UITextField.ViewMode.always
        let searchImage = UIImage(named: "search_icon")
        searchButton.setImage(searchImage, for: .normal)
        searchQueryTextField.leftView = searchButton
        searchButton.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
}

//MARK: - IBActions
extension HeaderSearchView {
    
    @objc func didTap(_ sender: UIButton) {
        expand()
        searchQueryTextField.becomeFirstResponder()
    }
    
}

//MARK: - UITextFieldDelegate
extension HeaderSearchView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        expand()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        expand()
    }
    
}

//MARK: - Animating View
extension HeaderSearchView {
    
    @objc func expand() {
        anim.addAnimations {
            self.heightFromSuperviewConstraint?.constant = 82
            self.navigationChainLabel.font = self.navigationChainLabel.font.withSize(13)
            self.footerStackViewTopConstraint.constant = 12
            self.clearSearchQueryButton.alpha = 1
            self.queryTextFieldHeightConstraint.constant = 34
            self.searchQueryTextFieldRightConstraint.constant = 12
            self.searchQueryTextField.textColor = .black
            self.auxiliaryLabel.alpha = 0
            self.layoutIfNeeded()
        }
        
        anim.startAnimation()
    }
    
    func collapse() {
        searchQueryTextField.resignFirstResponder()
        auxiliaryLabel.text = searchQueryTextField.text
        
        anim.addAnimations {
            self.heightFromSuperviewConstraint?.constant = 60
            self.navigationChainLabel.font = self.navigationChainLabel.font.withSize(10)
            self.footerStackViewTopConstraint.constant = 2
            self.clearSearchQueryButton.alpha = 0
            self.searchQueryTextFieldRightConstraint.constant = self.frame.width - 32
            self.queryTextFieldHeightConstraint.constant = 20
            self.searchQueryTextField.textColor = .white
            self.auxiliaryLabel.alpha = 1
            self.layoutIfNeeded()
        }
        
        anim.startAnimation()
    }
    
}
