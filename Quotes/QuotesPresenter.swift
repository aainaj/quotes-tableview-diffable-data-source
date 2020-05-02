//
//  QuotesPresenter.swift
//  Quotes
//
//  Created by Aaina Jain on 02/05/20.
//  Copyright © 2020 Aaina Jain. All rights reserved.
//

import Foundation

final class QuotesPresenter {
    let anonymousAuthor = "Anonymous"
    
    lazy var quotesDict: [Author: Set<QuoteViewData>] = {
        return makeQuotesList()
    }()
    
    func appendQuote() {
        let viewData = QuoteViewData(text: "Live and Let live")
//        if !(quotesDict[anonymousAuthor]?.first(where: { $0.hashValue == viewData.hashValue }) ?? false) {
            quotesDict[anonymousAuthor]?.insert(viewData)
    }
}

private extension QuotesPresenter {
    func makeQuotesList() -> [Author: Set<QuoteViewData>] {
        let quotesList: [Quote] = Bundle.main.decode(from: "quotes")
        var quotesDictionary: [Author: Set<QuoteViewData>] = [:]
        quotesList.forEach { quote in
            let quoteViewData = QuoteViewData(text: quote.text)
            let author = quote.author ?? anonymousAuthor
            
            if quotesDictionary[author] == nil {
                quotesDictionary[author] = [quoteViewData]
            } else {
                var viewData = quotesDictionary[author]
                viewData?.insert(quoteViewData)
                quotesDictionary[author] = viewData
            }
        }
        return quotesDictionary
    }
}

extension Set {
    var array: [Element] {
        return Array(self)
    }
}
