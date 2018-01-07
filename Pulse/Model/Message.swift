//
//  Message.swift
//  Pulse
//
//  Created by Luke Klinker on 1/4/18.
//  Copyright © 2018 Luke Klinker. All rights reserved.
//

import Alamofire

struct Message : ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible {
    
    let id: Int64
    let messageType: Int
    let data: String
    let mimeType: String
    let timestamp: Int64
    let sender: String?
    
    var description: String {
        return "Message: { id: \(id), data: \(data), mimetype: \(mimeType), timestamp: \(timestamp) }"
    }
    
    init?(response: HTTPURLResponse, representation: Any) {
        guard
            let representation = representation as? [String: Any],
            let id = representation["device_id"] as? Int64,
            let messageType = representation["message_type"] as? Int,
            let data = representation["data"] as? String,
            let mimeType = representation["mime_type"] as? String,
            let timestamp = representation["timestamp"] as? Int64
        else { return nil }
        
        self.id = id
        self.messageType = messageType
        self.data = Account.encryptionUtils?.decrypt(data: data) ?? ""
        self.mimeType = Account.encryptionUtils?.decrypt(data: mimeType) ?? "text/plain"
        self.timestamp = timestamp
        self.sender = Message.getOptionalString(representation: representation, key: "message_from")
    }
    
    private static func getOptionalString(representation: [String: Any], key: String) -> String? {
        let value = representation[key]
        if (!(value is NSNull)) {
            return Account.encryptionUtils?.decrypt(data: (value as? String)!) ?? nil
        } else {
            return nil
        }
    }
}

class MessageType {
    static let RECEIVED = 0
    static let SENT = 1
    static let SENDING = 2
    static let ERROR = 3
    static let DELIVERED = 4
    static let INFO = 5
    static let MEDIA = 6
}

class MimeType {
    static let TEXT_PLAIN = "text/plain"
    static let TEXT_HTML = "text/html"
    static let TEXT_VCARD = "text/vcard"
    static let TEXT_X_VCARD = "text/x-vcard"
    static let TEXT_X_VCALENDAR = "text/x-vcalendar"
    static let TEXT_DIRECTORY = "text/directory"
    static let TEXT_DIRECTORY_VCARD_PROFILE = "text/directory;profile=vCard"
    static let APPLICATION_VCARD = "application/vcard"
    static let IMAGE_JPEG = "image/jpeg"
    static let IMAGE_BMP = "image/bmp"
    static let IMAGE_JPG = "image/jpg"
    static let IMAGE_PNG = "image/png"
    static let IMAGE_GIF = "image/gif"
    static let VIDEO_MPEG = "video/mpeg"
    static let VIDEO_3GPP = "video/3gpp"
    static let VIDEO_MP4 = "video/mp4"
    static let AUDIO_MP3 = "audio/mpeg"
    static let AUDIO_MP3_2 = "audio/mp3"
    static let AUDIO_MP4 = "audio/mp4"
    static let AUDIO_OGG = "audio/ogg"
    static let AUDIO_WAV = "audio/vnd.wav"
    static let AUDIO_3GP = "audio/3gp"
    static let AUDIO_AMR = "audio/amr"
    static let MEDIA_YOUTUBE_V2 = "media/youtube-v2"
    static let MEDIA_ARTICLE = "media/web"
    static let MEDIA_TWITTER = "media/twitter"
}