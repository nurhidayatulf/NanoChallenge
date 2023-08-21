//
//  MyLuggageViewModel.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 20/08/23.
//

import SwiftUI

final class MyLuggageViewModel: ObservableObject {
    @AppStorage("items2") var itemsData2: Data = Data()
    @Published var isShowingAddItemView2 = false
    @Published var newItemName2 = ""
    @Published var newItemColor2 = Color.gray
    @Published var newItemImage2: UIImage? = nil
    @Published var items2: [MyLuggageItem] = []
    @Published var itemsCount2 = 0
    
    func saveItems2() {
        do {
            let encodedData = try JSONEncoder().encode(items2)
            itemsData2 = encodedData
            updateItemCount2() // Memperbarui itemsCount setiap kali item disimpan
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
    }
    
    func loadItems2() {
        do {
            let decodedItems = try JSONDecoder().decode([MyLuggageItem].self, from: itemsData2)
            items2 = decodedItems
            updateItemCount2() // Memperbarui itemsCount setiap kali item dimuat
        } catch {
            print("Error loading items: \(error.localizedDescription)")
        }
    }
    
    func updateItemCount2() {
        itemsCount2 = items2.count
    }
}
