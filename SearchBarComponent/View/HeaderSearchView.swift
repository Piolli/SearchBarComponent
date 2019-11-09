//
//  HeaderSearchView.swift
//  SearchBarComponent
//
//  Created by Alexandr on 09.11.2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import UIKit

protocol HeaderSearchViewDelegate {
    
    func searchButtonWasTappedWith(query: String)
    
}

class HeaderSearchView: UIView {
    
    @IBOutlet weak var clearSearchQueryButton: UIButton!
    @IBOutlet weak var navigationChainLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    public var delegate: HeaderSearchViewDelegate?
    
    private var searchButton: UIButton!
    private var auxiliaryLabel: UILabel!
    
    @IBOutlet weak var queryTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var searchQueryTextFieldRightConstraint: NSLayoutConstraint!
    private weak var heightFromSuperviewConstraint: NSLayoutConstraint!
    
    lazy private var animator: UIViewPropertyAnimator = UIViewPropertyAnimator(
        duration: 0.25,
        timingParameters: UISpringTimingParameters()
    )
    
    @IBOutlet weak var searchQueryTextField: UITextField! {
        didSet {
            self.searchQueryTextField.layer.borderWidth = 1.0
            self.searchQueryTextField.layer.borderColor = UIColor.blue.cgColor
            self.searchQueryTextField.layer.cornerRadius = 8
            self.searchQueryTextField.delegate = self
            self.searchQueryTextField.addTarget(self, action: #selector(expand), for: .touchDown)
            addSearchButtonToTextField()
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
            self.constraints.forEach { [unowned self] (constraint) in
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
        navigationChainLabel.text = "Поиск по всему каталогу"
        searchQueryTextField.resignFirstResponder()
    }
    
}

//MARK: - Initializers
extension HeaderSearchView {
    
    private func setUp() {
        setUpViewFromNib()
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
        searchButton = UIButton(type: .roundedRect)
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
        if animator.isRunning {
            return
        }
        expand()
        searchQueryTextField.becomeFirstResponder()
    }
    
}

//MARK: - UITextFieldDelegate
extension HeaderSearchView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.searchButtonWasTappedWith(query: textField.text ?? "")
        return true
    }
    
}

//MARK: - Animating View
extension HeaderSearchView {
    
    @objc func expand() {
        animator.addAnimations { [unowned self] in
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
        
        animator.startAnimation()
    }
    
    func collapse() {
        searchQueryTextField.resignFirstResponder()
        auxiliaryLabel?.text = searchQueryTextField.text
        
        animator.addAnimations { [unowned self] in
            self.heightFromSuperviewConstraint?.constant = 60
            self.navigationChainLabel.font = self.navigationChainLabel.font.withSize(10)
            self.footerStackViewTopConstraint.constant = 2
            self.clearSearchQueryButton.alpha = 0
            self.searchQueryTextFieldRightConstraint.constant = self.frame.width - 32
            self.queryTextFieldHeightConstraint.constant = 20
            self.searchQueryTextField.textColor = .white
            self.auxiliaryLabel?.alpha = 1
            self.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
    
}
