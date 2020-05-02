//
//  ViewController.swift
//  Quotes
//
//  Created by Aaina Jain on 01/05/20.
//  Copyright © 2020 Aaina Jain. All rights reserved.
//

import UIKit

final class QuotesViewController: UIViewController {
    private let quotesView: QuotesView = QuotesView.build()
    
    private lazy var presenter = QuotesPresenter()
    
    override func loadView() {
        view = UIView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Inspirational Quotes"
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Shuffle", style: .done, target: self, action: #selector(shuffle)), UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))]
        let dict = presenter.quotesDict
        quotesView.applySnapshot(for: dict, sections: dict.keys.sorted())
    }
    
    @objc func add() {
        presenter.appendQuote()
        let dict = presenter.quotesDict
        quotesView.applySnapshot(for: dict, sections: dict.keys.sorted())
    }
    
    @objc func shuffle() {
        quotesView.shuffleSections(for: presenter.quotesDict)
    }
}

// MARK: Private functions
private extension QuotesViewController {
    func setupViews() {
        view.addSubview(quotesView)
        applyConstraints()
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            quotesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            quotesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: quotesView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: quotesView.bottomAnchor)
        ])
    }
}

