//
//  QuotesView.swift
//  Quotes
//
//  Created by Aaina Jain on 01/05/20.
//  Copyright © 2020 Aaina Jain. All rights reserved.
//

import UIKit

final class QuotesView: UIView {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dataSource = makeDataSource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applySnapshot(for dictionary: [Author: Set<QuoteViewData>], sections: [Author]) {
        var snapshot = NSDiffableDataSourceSnapshot<Author, QuoteViewData>()
        snapshot.appendSections(sections)
        
        dictionary.forEach { key, value in
            snapshot.appendItems(value.array, toSection: key)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func shuffleSections(for dictionary: [Author: Set<QuoteViewData>]) {
        let sections = dictionary.keys.shuffled()
        applySnapshot(for: dictionary, sections: sections)
    }
}

extension QuotesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) 
    }
}

private extension QuotesView {
    func setupViews() {
        addSubview(tableView)

        applyConstraints()

        registerCells()
        tableView.dataSource = dataSource
    }
    
    func registerCells() {
        tableView.register(UITableViewCell.self)
    }

    func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
}

//MARK: Prepare data source
private extension QuotesView {
    func makeDataSource() -> UITableViewDiffableDataSource<Author, QuoteViewData> {
        return QuotesViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, quote in
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
                cell.textLabel?.text = quote.text
                return cell
            }
        )
    }
}
