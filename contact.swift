import SwiftUI

struct ContactView: View {
    @State private var isAdding = false
    @State private var isEditing = false
    @State private var conName: String = ""
    @State private var conNum: String = ""
    static var savedContacts: [(name: String, number: String)] = []
    @State private var editingIndex: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    self.isAdding = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Speeder")
                            .font(.title2)
                            .padding(20)
                    }
                }
                .sheet(isPresented: $isAdding, content: {
                    VStack {
                        TextField("Contact Name", text: $conName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        TextField("Phone Number", text: $conNum)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            ContactView.savedContacts.append((name: self.conName, number: self.conNum))
                            self.conName = ""
                            self.conNum = ""
                            self.isAdding = false
                        }) {
                            Text("Save")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .padding()
                })

                List {
                    ForEach(ContactView.savedContacts.indices, id: \.self) { index in
                        HStack {
                            VStack(alignment:.leading) {
                                Text("\(ContactView.savedContacts[index].name)")
                            }
                            Spacer()
                            Button(action: {
                                self.conName = ContactView.savedContacts[index].name
                                self.conNum = ContactView.savedContacts[index].number
                                self.editingIndex = index
                                self.isEditing = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                            }
                            .sheet(isPresented: self.$isEditing) {
                                VStack {
                                    TextField("Contact Name", text: $conName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    TextField("Phone Number", text: $conNum)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    
                                    Button(action: {
                                        if let index = self.editingIndex {
                                            ContactView.savedContacts[index] = (name: self.conName, number: self.conNum)
                                        }
                                        self.conName = ""
                                        self.conNum = ""
                                        self.isEditing = false
                                    }) {
                                        Text("Save")
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                }
                                .padding()
                            }
                        }
                    }
                }
                .navigationBarTitle("Contacts")
                .navigationBarItems(trailing:
                        NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                        Text("Done")
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                )
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
