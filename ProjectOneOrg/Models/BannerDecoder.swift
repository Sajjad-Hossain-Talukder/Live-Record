//
//  BannerDecoder.swift
//  LiveRecordHome
//
//  Created by Xotech on 10/02/2024.
//

import UIKit


struct BannerDecoder : Decodable {
    let CrossPromotions : [Item]
}

struct Item : Decodable {
    let id : Int
    let title : String
    let image_url : String
    let promotional_url : String!
}
