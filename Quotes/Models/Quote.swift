//
//  Quote.swift
//  Quotes
//
//  Created by Aaina Jain on 02/05/20.
//  Copyright © 2020 Aaina Jain. All rights reserved.
//

import Foundation

struct Quote: Hashable, Codable {
    let text: String
    let author: String?
}

