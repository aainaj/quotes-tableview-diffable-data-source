//
//  QuotesViewDiffableDataSource.swift
//  Quotes
//
//  Created by Aaina Jain on 02/05/20.
//  Copyright © 2020 Aaina Jain. All rights reserved.
//

import UIKit

final class QuotesViewDiffableDataSource: UITableViewDiffableDataSource<Author, QuoteViewData> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return snapshot().sectionIdentifiers[section]
    }
    
    // MARK: editing support
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let identifierToDelete = itemIdentifier(for: indexPath) else {
            return
        }
        var snapshot = self.snapshot()
        snapshot.deleteItems([identifierToDelete])
        apply(snapshot)
    }
}
