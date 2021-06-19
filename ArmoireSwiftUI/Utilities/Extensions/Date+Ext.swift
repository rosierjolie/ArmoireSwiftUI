//
// Date+Ext.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/19/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Foundation

extension Date {
    func convertToDayMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: self)
    }
}
