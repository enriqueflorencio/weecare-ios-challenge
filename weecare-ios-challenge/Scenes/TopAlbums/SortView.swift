//
//  SortView.swift
//  weecare-ios-challenge
//
//  Created by Enrique Florencio on 9/27/21.
//

import Foundation
import UIKit

public class SortView: UIView {
    private let container = UIView()
    private let tableView = UITableView()
    private let sortLabel = UILabel()
    private let categories = ["A-Z", "New", "Popular"]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
        configureGestureRecognizer()
        configureContainer()
        configureTableView()
        animateIn()
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            animateOut()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        addSubview(container)
        NSLayoutConstraint.activate([
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor),
            container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35)
        
        ])
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        sortLabel.text = "Sort Results By"
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
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

extension SortView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
        cell.circularView.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
        tableView.deselectRow(at: indexPath, animated: true)
        animateOut()
    }
}

extension SortView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        cell.categoryString = categories[indexPath.row]
        return cell
    }
    
    
}

extension SortView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: container) == true) {
            return false
        }
        return true
    }
}

extension SortView {
    @objc private func animateOut() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
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

