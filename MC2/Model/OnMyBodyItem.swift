//
//  OnMyBodyItem.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 21/08/23.
//

import SwiftUI

struct OnMyBodyItem: Identifiable, Codable {
    var id: UUID
    var name: String
    var color: Color = Color("Text")
    var imageData: Data?
    
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    init(id: UUID = UUID(), name: String, color: Color, image: UIImage?) {
        self.id = id
        self.name = name
        self.color = color
        self.imageData = image?.pngData()
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, color, imageData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageData = try container.decode(Data?.self, forKey: .imageData)
        if let colorData = try container.decode(Data?.self, forKey: .color),
           let unarchivedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            color = Color(unarchivedColor)
        } else {
            color = Color.gray
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageData, forKey: .imageData)
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false) {
            try container.encode(colorData, forKey: .color)
        }
    }
}
