//
//  NewRestaurantView.swift
//  FoodPin
//
//  Created by 凌有道 on 2023/11/22.
//

import SwiftUI

struct NewRestaurantView: View {
    @State private var restaurantImage = UIImage(named: "newphoto")!
    
    @State private var showPhotoOptions = false
    
    enum PhotoSource: Identifiable{
        case photoLibrary
        case camera
        
        var id: Int{
            hashValue
        }
    }
    
    @State private var photoSource: PhotoSource?
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        NavigationView{
            
            ScrollView{
                VStack{
                    Image(uiImage: restaurantImage)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom)
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                    
                    FormTextField(label: "Name", placeholder: "Fill in the restaurant name", value: .constant(""))
                    
                    FormTextField(label: "Type", placeholder: "fill in the restaurant type", value: .constant(""))
                    
                    FormTextField(label: "Address", placeholder: "fill in the restaurant address", value: .constant(""))
                    
                    FormTextField(label: "Phone", placeholder: "Fill in the restaurant phone", value: .constant(""))
                    
                    FormTextView(label: "Description", value: .constant(""), height: 100)
                }
                .padding()
            }
            .navigationTitle("New Restaurant")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "xmark")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Text("save")
                        .font(.headline)
                        .foregroundColor(Color("NavigationBarTitle"))

                }
              
        }
        .actionSheet(isPresented: $showPhotoOptions) {
            ActionSheet(title: Text("Choose your photo source"), message: nil,
                buttons: [
                    .default(Text("Camera")){
                        self.photoSource = .camera
                    },
                    .default(Text("Photo Library")){
                        self.photoSource = .photoLibrary
                    },
                    .cancel()
            ])
        }
        .fullScreenCover(item: $photoSource) {source in
            switch source{
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $restaurantImage).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $restaurantImage).ignoresSafeArea()
            }
            
        }

    }
        .accentColor(.primary)
}
}

struct FormTextField: View{
    let label: String
    var placeholder: String = ""
    
    @Binding var value: String
    
    var body: some View{
        VStack(alignment: .leading){
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextField(placeholder, text: $value)
                .font(.system(.body, design: .rounded))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(.systemGray5),lineWidth: 1)
                )
                .padding(.vertical, 10)
            
        }
    }
}

struct FormTextView: View{
    let label: String
    @Binding var value: String
    var height: CGFloat = 200.0
    
    var body: some View{
        VStack(alignment: .leading){
            Text(label.uppercased())
                .font(.system(.headline, design: .rounded))
                .foregroundColor(Color(.darkGray))
            
            TextEditor(text: $value)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.top, 10)
        }
    }
}

struct NewRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NewRestaurantView()
        
        FormTextField(label: "NAMR", placeholder: "Fill in the restaurant name", value: .constant(""))
            .previewLayout(.fixed(width: 300, height: 200))
        
        FormTextView(label: "description", value: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
