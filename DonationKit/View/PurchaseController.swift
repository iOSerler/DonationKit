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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: purchasePresenter.config.imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        if purchasePresenter.config.titleLabelFontName.isEmpty {
            label.font = UIFont.systemFont(ofSize: purchasePresenter.config.titleLabelFontSize, weight: .semibold)
        } else {
            label.font = UIFont(name: purchasePresenter.config.titleLabelFontName, size: purchasePresenter.config.titleLabelFontSize)
        }
        
        label.textColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor)
        
        label.text = purchasePresenter.config.titleLabelText
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        if purchasePresenter.config.bodyLabelFontName.isEmpty {
            label.font = UIFont.systemFont(ofSize: purchasePresenter.config.bodyLabelFontSize)
        } else {
            label.font = UIFont(name: purchasePresenter.config.bodyLabelFontName, size: purchasePresenter.config.bodyLabelFontSize)
        }
        
        label.textColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor)
        
        label.text = purchasePresenter.config.bodyLabelText
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if purchasePresenter.config.type == "Recurring" {
            let recurringSize = CGSize(width: (self.view.bounds.width - 32), height: 80)
            layout.itemSize = recurringSize
        } else {
            let oneTimeSize = CGSize(width: (self.view.bounds.width - 90)/3, height: 50)
            layout.itemSize = oneTimeSize
        }
        
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(OneTimeDonationCell.self, forCellWithReuseIdentifier: "OneTimeDonationCell")
        collectionView.register(RecurringDonationCell.self, forCellWithReuseIdentifier: "RecurringDonationCell")

        return collectionView
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(purchasePresenter.config.purchaseButtonTitle, for: UIControl.State())
        
        if purchasePresenter.config.purchaseButtonFontName.isEmpty {
            button.titleLabel?.font = UIFont.systemFont(ofSize: purchasePresenter.config.purchaseButtonFontSize, weight: .semibold)
        } else {
            button.titleLabel?.font = UIFont(name: purchasePresenter.config.purchaseButtonFontName, size: purchasePresenter.config.purchaseButtonFontSize)
        }
        
        button.setTitleColor(UIColor(rgb: purchasePresenter.config.purchaseButtonTitleHexColor), for: .normal)
        
        
        button.backgroundColor = UIColor(rgb: purchasePresenter.config.purchaseButtonBackgroundHexColor)
        
        
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
        
        if purchasePresenter.config.secondaryButtonFontName.isEmpty {
            button.titleLabel?.font = UIFont.systemFont(ofSize: purchasePresenter.config.secondaryButtonFontSize, weight: .semibold)
        } else {
            button.titleLabel?.font = UIFont(name: purchasePresenter.config.secondaryButtonFontName, size: purchasePresenter.config.secondaryButtonFontSize)
        }
        
        button.setTitleColor(UIColor(rgb: purchasePresenter.config.secondaryButtonTitleHexColor), for: .normal)
        
        
        button.backgroundColor = UIColor(rgb: purchasePresenter.config.secondaryButtonBackgroundHexColor)
        
        
        button.addTarget(self, action: #selector(secondaryButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = UIColor(rgb: purchasePresenter.config.backgroundHexColor)
        
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(bodyLabel)
        self.view.addSubview(priceCollectionView)
        self.view.addSubview(purchaseButton)
        self.view.addSubview(secondaryButton)
        self.view.addSubview(activityIndicator)
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        if #available(iOS 11.0, *) {
            self.imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24  ).isActive = true
        } else {
            self.imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
            self.secondaryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        }
        
        self.imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10).isActive = true
        
        self.titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bodyLabel.topAnchor, constant: -8).isActive = true
        
        self.bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.bodyLabel.bottomAnchor.constraint(greaterThanOrEqualTo: priceCollectionView.topAnchor, constant: -16).isActive = true
        
        self.priceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        self.priceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        self.priceCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        self.priceCollectionView.bottomAnchor.constraint(lessThanOrEqualTo: purchaseButton.topAnchor, constant: -8).isActive = true
        
        self.purchaseButton.bottomAnchor.constraint(equalTo: secondaryButton.topAnchor, constant: -8).isActive = true
        self.purchaseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.purchaseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.purchaseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.secondaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        self.secondaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        self.secondaryButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
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
        self.imageView.isHidden = false
        self.titleLabel.isHidden = false
        self.bodyLabel.isHidden = false
        self.purchaseButton.isHidden = false
        self.secondaryButton.isHidden = self.purchasePresenter.config.isSecondaryButtonHidden
    }
    
    public func showFailureViews() {
        UIView.animate(withDuration: 0.2, animations: {
            self.purchaseButton.alpha = 0
            self.bodyLabel.alpha = 0
        }) { _ in
            self.bodyLabel.text = self.purchasePresenter.config.purchaseFailedText
            self.purchaseButton.setTitle(self.purchasePresenter.config.tryAgainButtonTitle, for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0.2, animations: {
                self.bodyLabel.alpha = 1
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
        
        if purchasePresenter.config.type == "Recurring" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecurringDonationCell", for: indexPath) as! RecurringDonationCell
            cell.titleLabel.text = purchasePresenter.prices[indexPath.item]
            cell.bodyLabel.text = purchasePresenter.titles[indexPath.item]
            cell.iconImageView.image = UIImage(named: "heart")
            if purchasePresenter.chosenProductIndex == indexPath.item {
                
                cell.titleLabel.textColor = UIColor(rgb: purchasePresenter.config.purchaseButtonTitleHexColor)
                cell.bodyLabel.textColor = UIColor(rgb: purchasePresenter.config.purchaseButtonTitleHexColor)
                cell.contentView.backgroundColor = UIColor(rgb: purchasePresenter.config.purchaseButtonBackgroundHexColor)
                cell.contentView.layer.borderColor = UIColor(rgb: purchasePresenter.config.purchaseButtonBackgroundHexColor).cgColor
                
                
            } else {
                
                cell.titleLabel.textColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor)
                cell.bodyLabel.textColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor)
                cell.contentView.backgroundColor = UIColor(rgb: purchasePresenter.config.backgroundHexColor)
                cell.contentView.layer.borderColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor).cgColor
            }
            
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneTimeDonationCell", for: indexPath) as! OneTimeDonationCell
        
        cell.textLabel.text = purchasePresenter.prices[indexPath.item]
        if purchasePresenter.chosenProductIndex == indexPath.item {
            
            cell.textLabel.textColor = UIColor(rgb: purchasePresenter.config.purchaseButtonTitleHexColor)
            
            
            cell.textLabel.backgroundColor = UIColor(rgb: purchasePresenter.config.purchaseButtonBackgroundHexColor)
            cell.textLabel.layer.borderColor = UIColor(rgb: purchasePresenter.config.purchaseButtonBackgroundHexColor).cgColor
            
            
        } else {
            
            cell.textLabel.textColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor)
            cell.textLabel.backgroundColor = UIColor(rgb: purchasePresenter.config.backgroundHexColor)
            cell.textLabel.layer.borderColor = UIColor(rgb: purchasePresenter.config.bodyLabelHexColor).cgColor
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
