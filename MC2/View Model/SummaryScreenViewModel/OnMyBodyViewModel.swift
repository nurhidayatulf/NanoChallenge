//
//  OnMyBodyViewModel.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 18/08/23.
//

import SwiftUI

final class OnMyBodyViewModel: ObservableObject {
    @AppStorage("items") var itemsData: Data = Data()
    @Published var isShowingAddItemView = false
    @Published var newItemName = ""
    @Published var newItemColor = Color.gray
    @Published var newItemImage: UIImage? = nil
    @Published var items: [OnMyBodyItem] = []
    @Published var itemsCount = 0
    
    func saveItems() {
        do {
            let encodedData = try JSONEncoder().encode(items)
            itemsData = encodedData
            updateItemCount()
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
    }
    
    func loadItems() {
        do {
            let decodedItems = try JSONDecoder().decode([OnMyBodyItem].self, from: itemsData)
            items = decodedItems
            updateItemCount()
        } catch {
            print("Error loading items: \(error.localizedDescription)")
        }
    }
    
    func updateItemCount() {
        itemsCount = items.count
    }
}

final class addItemViewModel: ObservableObject {
    //untuk reset nama item
    @Published var itemNameInput: String = "Item's Name"
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showImageSourceActionSheet = false
    @Published var toggleIsOn: Bool = true
    @Published var itemImage: UIImage?
    
    var isPhotoSelected: Bool {
        return itemImage != nil
    }
    
    enum SelectionOption {
        case photo, color
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Empty implementation
    }
}
