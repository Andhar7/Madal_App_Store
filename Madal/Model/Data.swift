//
//  Data.swift
//  Madal
//
//  Created by Solver on 14.04.2022.
//

import SwiftUI

enum Category : String {
    
    case Favourites = "Favourite"
    case Main = "Main"
    case Library  = "Library"
    case Races = "Races"
    case Centre = "Centre"
    case Radio = "Radio"
    case Videos = "Videos"
    case Songs = "Songs"
    case PeaceRun = "Peace Run"
    
}

struct MenuItem : Identifiable, Hashable {
    
    var id : Category
    let image : String
    var category : String {
        return id.rawValue
    }
}

let MenuItems = [

    MenuItem(id: Category.Favourites, image: "star.fill"),
    MenuItem(id: Category.Main, image: "house"),
    MenuItem(id: Category.Library, image: "books.vertical"),
    MenuItem(id: Category.Races, image: "figure.walk"),
    MenuItem(id: Category.Centre, image: "figure.wave"),
    MenuItem(id: Category.Radio, image: "radio"),
    MenuItem(id: Category.Videos, image: "video.bubble.left.fill"),
    MenuItem(id: Category.Songs, image: "music.note"),
    MenuItem(id: Category.PeaceRun, image: "globe.europe.africa")
]

struct WebsiteItem : Identifiable, Hashable {
    
    let id: String
    let image: String
    let category : String
    let url : String
}

let webSitesItems = [
 
    WebsiteItem(id: "Main", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org"),
    WebsiteItem(id: "Sri Chinmoy About", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org/sri_chinmoy"),
    WebsiteItem(id: "Spirituality", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org/spirituality"),
    WebsiteItem(id: "Service", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org/service"),
    WebsiteItem(id: "Resources", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org/resources"),
    WebsiteItem(id: "Kind Words", image: "bird", category: Category.Main.rawValue, url: "https://srichinmoy.org/kind_words"),
    
    WebsiteItem(id: "Library Main", image: "bird", category: Category.Library.rawValue, url: "https://www.srichinmoylibrary.com"),
    WebsiteItem(id: "All Books", image: "bird", category: Category.Library.rawValue, url: "https://www.srichinmoylibrary.com/allbooks"),
    WebsiteItem(id: "About Sri Chinmoy", image: "bird", category: Category.Library.rawValue, url: "https://www.srichinmoylibrary.com/srichinmoy"),
    WebsiteItem(id: "Covers", image: "bird", category: Category.Library.rawValue, url: "https://www.srichinmoylibrary.com/allcovers"),

    
    WebsiteItem(id: "Sri Chinmoy Races", image: "bird", category: Category.Races.rawValue, url: "https://www.srichinmoyraces.org"),
    WebsiteItem(id: "About Us", image: "bird", category: Category.Races.rawValue, url: "https://www.srichinmoyraces.org/about"),
    WebsiteItem(id: "Our Races", image: "bird", category: Category.Races.rawValue, url: "https://www.srichinmoyraces.org/events"),
    WebsiteItem(id: "Results", image: "bird", category: Category.Races.rawValue, url: "https://www.srichinmoyraces.org/results"),
    WebsiteItem(id: "3100 Mile Race", image: "bird", category: Category.Races.rawValue, url: "https://3100.srichinmoyraces.org"),
   
    
    WebsiteItem(id: "Sri Chinmoy Center", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org"),
    WebsiteItem(id: "About", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org/sri_chinmoy_centre"),
    WebsiteItem(id: "Sri Chinmoy", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org/sri_chinmoy"),
    WebsiteItem(id: "Meditation", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org/meditation"),
    WebsiteItem(id: "Our members", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org/members"),
    WebsiteItem(id: "Latest news", image: "bird", category: Category.Centre.rawValue, url: "https://www.srichinmoycentre.org/news"),
    
    WebsiteItem(id: "Sri Chinmoy Radio", image: "bird", category: Category.Radio.rawValue, url: "https://www.radiosrichinmoy.org"),
    WebsiteItem(id: "About Radio", image: "bird", category: Category.Radio.rawValue, url: "https://www.radiosrichinmoy.org/about/"),
    WebsiteItem(id: "Sri Chinmoy", image: "bird", category: Category.Radio.rawValue, url: "https://www.radiosrichinmoy.org/sri-chinmoy/"),
    WebsiteItem(id: "Meditation music", image: "bird", category: Category.Radio.rawValue, url: "https://www.radiosrichinmoy.org/meditation-music/"),
    WebsiteItem(id: "Latest releases", image: "bird", category: Category.Radio.rawValue, url: "https://www.radiosrichinmoy.org/new-releases/"),
    
    WebsiteItem(id: "Over 700 videos", image: "bird", category: Category.Videos.rawValue, url: "https://www.srichinmoy.tv"),
    WebsiteItem(id: "About this site", image: "bird", category: Category.Videos.rawValue, url: "https://www.srichinmoy.tv/about/"),
    WebsiteItem(id: "About Sri Chinmoy", image: "bird", category: Category.Videos.rawValue, url: "https://www.srichinmoy.tv/sri-chinmoy/"),
    WebsiteItem(id: "Latest releases", image: "bird", category: Category.Videos.rawValue, url: "https://www.srichinmoy.tv/new-releases/"),
    WebsiteItem(id: "Interviews", image: "bird", category: Category.Videos.rawValue, url: "https://www.srichinmoy.tv/videos-disciples/"),
    
    WebsiteItem(id: "Sri Chinmoy Songs", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com"),
    WebsiteItem(id: "Songbooks", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com/books"),
    WebsiteItem(id: "Latest changes", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com/recent"),
    WebsiteItem(id: "All songs (21300)", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com/allsongs"),
    WebsiteItem(id: "About Sri Chinmoy", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com/srichinmoy"),
    WebsiteItem(id: "About this site", image: "bird", category: Category.Songs.rawValue, url: "https://www.srichinmoysongs.com/about"),
    
    WebsiteItem(id: "Peace Run", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org"),
    WebsiteItem(id: "About", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/about/"),
    WebsiteItem(id: "Schools and Children", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/schools-and-kids/"),
    WebsiteItem(id: "Media", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/media/"),
    WebsiteItem(id: "Friends", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/friends/"),
    WebsiteItem(id: "Torch-Bearer Award", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/torch-bearer-award/"),
    WebsiteItem(id: "Peace Run Song", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/peace-run-song/"),
    WebsiteItem(id: "Contact Us", image: "bird", category: Category.PeaceRun.rawValue, url: "https://www.peacerun.org/gb/contact-us/")
]
