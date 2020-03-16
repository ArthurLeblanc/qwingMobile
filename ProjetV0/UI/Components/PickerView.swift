//
//  Picker.swift
//  ProjetV0
//
//  Created by Anthony Partinico on 12/03/2020.
//  Copyright © 2020 user164566. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    @State private var selection = 0
    let categories = ["Dans la rue","Dans les transports","Au travail","Autre"]
    
    var body: some View {
        
        
        Picker(selection: $selection, label:
        Text("Catégorie")) {
            ForEach(0 ..< categories.count) { index in
                Text(self.categories[index]).tag(index)
            }
        }
    }
}

struct Picker_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
