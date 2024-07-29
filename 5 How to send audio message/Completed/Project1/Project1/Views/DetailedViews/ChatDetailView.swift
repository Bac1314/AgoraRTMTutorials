//
//  ChatDetailView.swift
//  Project1
//
//  Created by BBC on 2024/5/16.
//

import SwiftUI
import AVFoundation


struct ChatDetailView: View {
    @EnvironmentObject var agoraRTMVM: AgoraRTMViewModel
    @Binding var friendContact: Contact
    @Binding var path: NavigationPath
    @FocusState var keyboardIsFocused: Bool
    @State var typeNewMessage: String = ""
    @State var lastMessageID: UUID = UUID() // for scrolling
    @State var showAudioRecord: Bool = false
    @State var isRecording: Bool = false
    
    var bottomID = UUID()
    
    // Audio Recorder & Player
    @State var audioRecorder: AVAudioRecorder!
    @State var audioPlayer: AVAudioPlayer!
    @State var currentRecordingURL: URL?
    
    var body: some View {
        // List of messages
        ZStack {
            
            // Show animating waveform when user is recording
            VStack{
                Image(systemName: "waveform")
                    .symbolEffect(.bounce, options: .speed(3).repeat(isRecording ? 600 : 0), value: isRecording)
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .padding(30)
                    .background(LinearGradient(colors: [Color.accentColor.opacity(0.5), Color.accentColor, Color.accentColor.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .opacity(isRecording ? 1 : 0)
            
            
            
            VStack {
                // MARK: DISPLAY LIST OF MESSAGES
                ScrollViewReader {proxy in
                    ScrollView{
                        ForEach(agoraRTMVM.messages.filter { message in
                            return filteredMessage(message: message)
                        }) { message in
                            
                            if let senderContact = agoraRTMVM.listOfContacts.first(where: {$0.userID == message.sender}) {
                                MessageItemView(contact: senderContact, customMessage: message, isSender: message.sender == agoraRTMVM.userID) {
                                    // Navigate to contact detail view
                                    path.append(customNavigateType.ContactDetailView(username: senderContact.userID))
                                }
                                .onTapGesture {
                                    if message.messageType == .audio {
                                        if let audioURL = message.messageLocalURL {
                                            playAudio(fileURL: audioURL)
                                        }
                                    }
                                }
                            }else {
                                Text("Contact not found")
                            }
                            
                        }
                        
                        // For scrolling to the bottom
                        Spacer(minLength: 50)
                            .id(bottomID)
                    }
                    .scrollDismissesKeyboard(.immediately)
                    .onAppear {
                        proxy.scrollTo(bottomID)
                    }
                    .onChange(of: agoraRTMVM.messages.count) { oldValue, newValue in
                        withAnimation {
                            print("Bac's messages count changed \(newValue)")
                            proxy.scrollTo(bottomID)
                        }
                        
                    }
                    .onChange(of: keyboardIsFocused) { old, new in
                        Task {
                            try? await Task.sleep(nanoseconds: 3 * 100_000_000)
                            withAnimation {
                                proxy.scrollTo(bottomID)
                            }
                        }
                        
                    }
                    
                }
                
                // MARK: SEND MESSAGE VIEW
                HStack{
                    // Recording button toggle
                    Button {
                        // Enable Audio Recording View
                        withAnimation {
                            showAudioRecord.toggle()
                        }
                    } label: {
                        Image(systemName: showAudioRecord ? "text.insert" : "speaker.wave.2")
                            .padding(12)
                            .foregroundStyle(!friendContact.online ? Color.secondary : Color.primary)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.gray, lineWidth: 1.0)
                            )
                            .aspectRatio(1, contentMode: .fill)
                    }
                    .disabled(!friendContact.online)

                    
                    // Text Message TextField AND Audio Recording
                    HStack{
                        if !showAudioRecord {
                            // Show text edit buttons
                            TextField("Enter Message", text: $typeNewMessage)
                                .textFieldStyle(.plain)
                                .focused($keyboardIsFocused)
                                .onSubmit {
                                    Task{
                                        let result = await agoraRTMVM.publishTextToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                                        
                                        if result {
                                            typeNewMessage = "" // Reset
                                        }
                                    }
                                }
                                .disabled(!friendContact.online)
                            
                            Button(action: {
                                Task{
                                    let result = await agoraRTMVM.publishTextToUser(userName: friendContact.userID, messageString: typeNewMessage, customType: nil)
                                    
                                    if result {
                                        typeNewMessage = "" // Reset
                                    }
                                }
                            }, label: {
                                Image(systemName: "paperplane")
                                    .imageScale(.large)
                            })
                            .disabled(typeNewMessage.isEmpty || !friendContact.online)
                        }else {
                            // Show audio recording button
                            Text(isRecording ?  "Recording..." : "Hold to record")
                                .foregroundStyle(Color.primary)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background()
                                .gesture(
                                    DragGesture(minimumDistance: 0.0)
                                        .onChanged { value in
                                            if isRecording == false {
                                                print("Bac's start recording")
                                                startRecording()
                                            }
                                        }
                                        .onEnded { value in
                                            print("Bac's end recording")
                                            stopRecording()
                                        }
                                )
                        }
                        
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.gray, lineWidth: 1.0)
                    )
                    
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(alignment: .center){
                        Text("\(friendContact.name.isEmpty ? friendContact.userID : friendContact.name)")
                            .font(.headline)
                            .onTapGesture {
                                // Navigate to contact detail view
                                path.append(customNavigateType.ContactDetailView(username: friendContact.userID))
                            }
                        
                        Image(systemName: "circle.fill")
                            .imageScale(.small)
                            .foregroundStyle(friendContact.online ? Color.green : Color.gray)
                    }
                    
                }
            }
        .toolbarTitleDisplayMode(.large)
        }
    }
    
    func filteredMessage(message: CustomMessage) -> Bool {
        return (message.sender == agoraRTMVM.userID && message.receiver == friendContact.userID) ||
        (message.sender == friendContact.userID && message.receiver == agoraRTMVM.userID)
    }
    
    // MARK: MEDIA CONTROL FUNCTIONS
    
    @MainActor
    func startRecording(){
        isRecording = true

        currentRecordingURL = agoraRTMVM.getDocumentsDirectory().appendingPathComponent("\(agoraRTMVM.userID)_\(Date().timeIntervalSince1970)_recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]

        do {
            if let recordingURL = currentRecordingURL {
                try AVAudioSession.sharedInstance().setCategory(.record, mode: .default)
                audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
                audioRecorder.record()
            }
        } catch {
            print("Recording failed")
        }
    }
    
    @MainActor
    func stopRecording(){
        // Stop recording
        isRecording = false
        audioRecorder.stop()
        audioRecorder = nil
        
        if let recordingURL = currentRecordingURL {
            Task {
                print("Bac's publishing to \(friendContact.userID)")
                await agoraRTMVM.publishFileToUser(userName: friendContact.userID, fileURL: recordingURL, messageType: .audio)
            }
            
        }
    }
    func playAudio(fileURL: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)

            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print("Failed to play audio file \(fileURL): \(error)")
        }
    }
}


#Preview {
    struct Preview: View {
        @State private var contact = Contact(userID: "bac1234", name: "Bac", gender: .male, company: "Agora", title: "TAM", description: "I work as a technical account manager (TAM) for Agora, based in the Shanghai office", avatar: "avatar_default", online: true)
        
        var body: some View {
            ChatDetailView(friendContact: $contact, path: .constant(NavigationPath()))
                .environmentObject(AgoraRTMViewModel())
        }
    }
    
    return Preview()
}
