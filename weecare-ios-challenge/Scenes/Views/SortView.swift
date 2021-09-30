//
//  SortView.swift
//  weecare-ios-challenge
//
//  Created by Enrique Florencio on 9/27/21.
//

import Foundation
import UIKit

public protocol SortViewDelegate: class {
    func didTapCategory(category: Int)
}

public class SortView: UIView {
    private let closeButton = UIButton()
    private let container = UIView()
    private let tableView = UITableView()
    private let sortLabel = UILabel()
    private let categories = ["Album Title", "Artist Name", "Release Date"]
    public weak var delegate: SortViewDelegate?
    private var currentSortingIndex: Int?
    private var containerConstraints = [NSLayoutConstraint]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
        configureGestureRecognizer()
        configureContainer()
        configureSortByLabel()
        configureExitButton()
        configureTableView()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.layer.cornerRadius = 5
        frame = UIScreen.main.bounds
        let currentOrientation = UIDevice.current.orientation
        if(currentOrientation == .landscapeLeft || currentOrientation == .landscapeRight) {
            removeContainerConstraints()
            layoutLandscape()
        } else if(currentOrientation == .portrait) {
            removeContainerConstraints()
            layoutPortrait()
        }
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            animateOut()
        }
    }
    
    //MARK: Configuration Functions
    
    private func configureSelf() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        frame = UIScreen.main.bounds
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureContainer() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 7
        container.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addSubview(container)
        layoutPortrait()
    }
    
    private func configureSortByLabel() {
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.text = "Sort Albums By"
        sortLabel.textAlignment = .center
        sortLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        container.addSubview(sortLabel)
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            sortLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            sortLabel.widthAnchor.constraint(equalTo: container.widthAnchor),
            sortLabel.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1)
        ])
    }
    
    private func configureExitButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)
        container.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            closeButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            closeButton.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.8),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        container.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            tableView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor)
        ])
    }
    
    //MARK: Layout Functions
    private func layoutLandscape() {
        containerConstraints.append(contentsOf:
            [container.bottomAnchor.constraint(equalTo: bottomAnchor),
             container.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
             container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
             container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65)]
        )
        NSLayoutConstraint.activate(containerConstraints)
    }
    
    private func layoutPortrait() {
        containerConstraints.append(contentsOf:
            [container.bottomAnchor.constraint(equalTo: bottomAnchor),
             container.centerXAnchor.constraint(equalTo: centerXAnchor),
             container.widthAnchor.constraint(equalTo: widthAnchor),
             container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.37)]
        )
        NSLayoutConstraint.activate(containerConstraints)
    }
    
    //MARK: Helper Functions
    private func removeContainerConstraints() {
        NSLayoutConstraint.deactivate(containerConstraints)
        containerConstraints.removeAll()
    }
    
    public func setSortingIndex(sortingIndex: Int) {
        currentSortingIndex = sortingIndex
    }
}

//MARK: Table View Delegation Functions
extension SortView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        cell.circularView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        tableView.deselectRow(at: indexPath, animated: true)
        animateOut()
        delegate?.didTapCategory(category: indexPath.row)
    }
}

//MARK: Data Source Functions
extension SortView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallbackCell = UITableViewCell()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ResultTableViewCell else {return fallbackCell}
        cell.categoryString = categories[indexPath.row]
        if(indexPath.row == currentSortingIndex) {
            cell.circularView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        }
        return cell
    }
}

//MARK: Gesture Recognizer Delegation Functions
extension SortView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: container) == true) {
            return false
        }
        return true
    }
}

//MARK: Animation Functions
extension SortView {
    @objc private func animateOut() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.alpha = 0
        } completion: { (complete) in
            if(complete) {
                self.removeFromSuperview()
            }
        }
    }
    
    private func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
}

