import SwiftUI

struct OnMyBodyView: View {
    @StateObject private var viewModelOnMyBody = OnMyBodyViewModel()
    @Binding var itemsCountOnMyBody: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView{
            ZStack{
                VStack (alignment: .leading) {
                    Image("OnMyBodyCoverPage")
                        .resizable()
                        .frame(height: 175)
                        .frame(maxWidth: .infinity)
                    HStack {
                        Image(systemName: "applewatch")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(Color("Text"))
                        Text("What’s On My Body?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Text"))
                    }.padding([.top, .leading], 20)
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(viewModelOnMyBody.items, id: \.id) { item in
                                RectangleViewOnMyBody(item: item, items: $viewModelOnMyBody.items)
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
                    viewModelOnMyBody.loadItems()
                    viewModelOnMyBody.updateItemCount()
                }
                .onDisappear {
                    viewModelOnMyBody.saveItems()
                }
                PlusButton(action: {
                    viewModelOnMyBody.isShowingAddItemView = true
                })
                .sheet(isPresented: $viewModelOnMyBody.isShowingAddItemView) {
                    AddItemOnMyBodyView(
                        isShowing: $viewModelOnMyBody.isShowingAddItemView,
                        itemName: $viewModelOnMyBody.newItemName,
                        itemColor: $viewModelOnMyBody.newItemColor,
                        itemImage: $viewModelOnMyBody.newItemImage,
                        items: $viewModelOnMyBody.items,
                        itemsCount: $itemsCountOnMyBody,
                        completion: { itemName in
                            viewModelOnMyBody.newItemName = itemName
                            viewModelOnMyBody.updateItemCount()
                        }
                    )
                }
            }
            .ignoresSafeArea()
            .background(.white)
        }
    }
}
struct AddItemOnMyBodyView: View {
    @StateObject private var viewModelAddItem = addItemViewModel()
    @Binding var isShowing: Bool
    @Binding var itemName: String
    @Binding var itemColor: Color
    @Binding var itemImage: UIImage?
    @Binding var items: [OnMyBodyItem]
    @Binding var itemsCount: Int
    @State var completion: (String) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack (alignment: .leading, spacing: 20) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 330, height: 230)
                            .foregroundColor(itemColor)
                        if viewModelAddItem.toggleIsOn == true {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 80)
                            if viewModelAddItem.isPhotoSelected {
                                if let image = viewModelAddItem.itemImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 330, height: 230)
                                        .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                                        .background(Color("Text"))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    Text("Item Name")
                        .foregroundColor(.black)
                        .padding(.bottom, -10)
                    TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $viewModelAddItem.itemNameInput)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(width: 330, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 10) .stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(10)
                    
                    Toggle(isOn: $viewModelAddItem.toggleIsOn,
                           label: {
                        Text("Use Picture")
                            .foregroundColor(.black)
                    }).toggleStyle(SwitchToggleStyle(tint: .green))
                        .frame(width: 330)
                    if viewModelAddItem.toggleIsOn == false{
                        ColorPicker("Pick a Color", selection:$itemColor)
                            .frame(width: 330)
                            .foregroundColor(.black)
                    }else{
                        Button(action: {
                            viewModelAddItem.showImageSourceActionSheet = true
                            viewModelAddItem.toggleIsOn = true
                        },label :{
                            HStack{
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                Text("Select Picture")
                                    .foregroundColor(.black)
                            }
                        })
                    }
                    
                    if viewModelAddItem.isPhotoSelected {
                        if viewModelAddItem.itemImage == nil {
                            Button(action: {
                                viewModelAddItem.showImageSourceActionSheet = true
                            }) {
                                Text("Add Picture")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                    
                    Spacer()
                    RoundedButton(title: "Add Item", action: {
                        let newItem: OnMyBodyItem
                        if viewModelAddItem.isPhotoSelected {
                            newItem = OnMyBodyItem(id: UUID(), name: viewModelAddItem.itemNameInput, color: .clear, image: viewModelAddItem.itemImage?.fixOrientation())
                        } else {
                            newItem = OnMyBodyItem(id: UUID(), name: viewModelAddItem.itemNameInput, color: itemColor, image: nil)
                        }
                        items.append(newItem)
                        viewModelAddItem.itemNameInput = "" // Reset itemNameInput to empty string
                        
                        isShowing = false
                        viewModelAddItem.itemImage = nil // Reset itemImage to nil
                    })
                }
                .frame(maxWidth: .infinity)
                .background(Color(.white))
                .navigationTitle($viewModelAddItem.itemNameInput)
                .navigationBarTitleDisplayMode(.inline)
                .actionSheet(isPresented: $viewModelAddItem.showImageSourceActionSheet) {
                    ActionSheet(
                        title: Text("Choose Photo Source"),
                        buttons: [
                            .default(Text("Camera"), action: {
                                viewModelAddItem.showImagePicker = true
                                viewModelAddItem.sourceType = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                viewModelAddItem.showImagePicker = true
                                viewModelAddItem.sourceType = .photoLibrary
                            }),
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $viewModelAddItem.showImagePicker) {
                    ImagePicker(image: $viewModelAddItem.itemImage, sourceType: $viewModelAddItem.sourceType)
                }
                //.navigationBarTitle("Tambah Item")
                .navigationBarItems(trailing: Button(action: {
                    isShowing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("Button"))
                })
            }
        }
    }
}

struct RectangleViewOnMyBody: View {
    var item: OnMyBodyItem
    @Binding var items: [OnMyBodyItem]
    
    var body: some View {
        ZStack (alignment: .center){
            if item.image != nil {
                Image(uiImage: item.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                    .background(Color("Text"))
                    .cornerRadius(15)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 150)
                    .foregroundColor(item.color)
            }
                VStack  {
                    HStack {
                        Spacer()
                        Button(action: {
                            removeItem(item)
                        }) {
                            ZStack{
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .frame(width: 25, height: 25)
                                    .shadow(radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(5)
                    }
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 150, height: 42)
                            .foregroundColor(Color("Button"))
                        Text(item.name)
                            .font(.body)
                            .frame(width: 130, height: 32)
                            .foregroundColor(.white)
                    }
//                    .padding(.top, -50)
                }
        }
        .frame(width: 175, height: 175)
//        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 4, x:0 ,y: 2)
    }
    
    func removeItem(_ item: OnMyBodyItem) {
        items.removeAll { $0.id == item.id }
    }
}

