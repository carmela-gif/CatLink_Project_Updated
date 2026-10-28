//
//  StrayReport.swift
//  CatLink_Project
//
//  Created by Mac-LAB on 10/27/26.
//

import Foundation

struct StrayReport: Identifiable {
    let id = UUID()
    var description: String
    var location: String
    var date: String
    var condition: String
    var additionalInformation: String
    var status: String
    var reporterName: String = ""
    var imageData: Data? = nil
}
