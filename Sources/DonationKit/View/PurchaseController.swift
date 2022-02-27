//
//  File.swift
//
//
//  Created by Daniya on 10/04/2020.
//


import UIKit

public class PurchaseController: UIViewController {
        
    private let purchasePresenter: PurchasePresenter
    
    public init(presenter: PurchasePresenter) {
        self.purchasePresenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.purchasePresenter.setViewDelegate(viewDelegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var visualImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = purchasePresenter.config.statementImage
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var statementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        let labelString = NSMutableAttributedString(string: purchasePresenter.config.statementLabelText, attributes: [
            NSAttributedString.Key.font : purchasePresenter.config.statementLabelFont,
            NSAttributedString.Key.foregroundColor : purchasePresenter.config.statementLabelColor,
            
        ])
        
        if let highlightedText = purchasePresenter.config.highlightedLabelText {
            
            let boldString = NSMutableAttributedString(string: highlightedText, attributes: [
                NSAttributedString.Key.font : purchasePresenter.config.highlightedLabelFont,
                NSAttributedString.Key.foregroundColor : purchasePresenter.config.statementLabelColor,
                
            ])
            labelString.append(boldString)
        }
        
        label.attributedText = labelString
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var pricePickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var priceCollectionView: UICollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: (self.view.bounds.width - 90)/3, height: 50)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
                
        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(purchasePresenter.config.purchaseButtonTitle, for: UIControl.State())
        button.titleLabel?.font = purchasePresenter.config.purchaseButtonFont
        button.setTitleColor(purchasePresenter.config.purchaseButtonTitleColor, for: .normal)
        button.backgroundColor = purchasePresenter.config.purchaseButtonBackgroundColor
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(purchaseButtonPressed(_:)), for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    private lazy var secondaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = purchasePresenter.config.isSecondaryButtonHidden
        button.setTitle(purchasePresenter.config.secondaryButtonTitle, for: UIControl.State())
        button.backgroundColor = purchasePresenter.config.secondaryButtonBackgroundColor
        button.setTitleColor(purchasePresenter.config.secondaryButtonTitleColor, for: .normal)
        button.titleLabel?.font = purchasePresenter.config.secondaryButtonFont
        button.addTarget(self, action: #selector(secondaryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor(red: 0xF4, green: 0xF4, blue: 0xF4, alpha: 1)
        self.title = purchasePresenter.config.title
        self.view.backgroundColor = purchasePresenter.config.backgroundColor
        self.view.addSubview(visualImageView)
        self.view.addSubview(statementLabel)
        self.view.addSubview(priceCollectionView)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(secondaryButton)
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        if #available(iOS 11.0, *) {
            self.visualImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        } else {
            self.visualImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        }
        
        self.statementLabel.topAnchor.constraint(equalTo: visualImageView.bottomAnchor, constant: 16).isActive = true
        self.statementLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.statementLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        self.priceCollectionView.topAnchor.constraint(greaterThanOrEqualTo: statementLabel.bottomAnchor, constant: 24).isActive = true
        self.priceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.priceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.priceCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.priceCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: purchaseButton.topAnchor, constant: -40).isActive = true
        
        self.purchaseButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: -16).isActive = true
        self.purchaseButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        self.visualImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.visualImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.visualImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        self.secondaryButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.secondaryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.secondaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc private func purchaseButtonPressed(_ sender: AnyObject) {
        purchasePresenter.makePurchase()
    }
    
    @objc private func secondaryButtonPressed() {
        purchasePresenter.doSecondaryAction()
    }
    
}

extension PurchaseController: PurchaseViewDelegate {
    
    public func startLoadingAnimation() {
        activityIndicator.startAnimating()
    }
    
    public func stopLoadingAnimation() {
        activityIndicator.stopAnimating()
    }
    
    public func showPurchaseViews() {
        self.priceCollectionView.reloadData()
        self.pricePickerView.reloadAllComponents()
        self.visualImageView.isHidden = false
        self.statementLabel.isHidden = false
        self.purchaseButton.isHidden = false
        self.secondaryButton.isHidden = self.purchasePresenter.config.isSecondaryButtonHidden
    }

    public func showFailureViews() {
        UIView.animate(withDuration: 0.2, animations: {
            self.purchaseButton.alpha = 0
            self.statementLabel.alpha = 0
        }) { _ in
            self.statementLabel.text = self.purchasePresenter.config.purchaseFailedText
            self.purchaseButton.setTitle(self.purchasePresenter.config.tryAgainButtonTitle, for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.statementLabel.alpha = 1
                self.purchaseButton.alpha = 1
            })
        }
    }
    
    public func showSuccessController() {
        self.navigationController?.pushViewController(SuccessController(presenter: purchasePresenter), animated: true)
    }
    
    public func pop() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension PurchaseController: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return purchasePresenter.prices.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PriceCollectionViewCell
        
        cell.textLabel.text = purchasePresenter.prices[indexPath.item]
        if purchasePresenter.chosenProductIndex == indexPath.item {
            cell.textLabel.textColor = purchasePresenter.config.purchaseButtonTitleColor
            cell.textLabel.backgroundColor = purchasePresenter.config.purchaseButtonBackgroundColor
            cell.textLabel.layer.borderColor = purchasePresenter.config.purchaseButtonBackgroundColor.cgColor
        } else {
            cell.textLabel.textColor = purchasePresenter.config.statementLabelColor
            cell.textLabel.backgroundColor = purchasePresenter.config.backgroundColor
            cell.textLabel.layer.borderColor = purchasePresenter.config.statementLabelColor.cgColor
        }
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        purchasePresenter.choosePrice(at: indexPath.item)
        collectionView.reloadData()
    }
    
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension PurchaseController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return purchasePresenter.prices.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.boldSystemFont(ofSize: 19)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        
        pickerLabel?.text = purchasePresenter.prices[row]
        
        return pickerLabel!;
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        purchasePresenter.choosePrice(at: row)
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300.0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
}
