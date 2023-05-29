//
//  CountryModel.swift
//  Assignment1
//
//  Created by Reshma Pai on 27/05/23.
//

import Foundation

public protocol EmptyDictionaryRepresentable {
    associatedtype CodingKeys : RawRepresentable where CodingKeys.RawValue == String
    associatedtype CodingKeyType: CodingKey = Self.CodingKeys
}

extension KeyedDecodingContainer {
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T?
        where T : Decodable & EmptyDictionaryRepresentable
    {
        guard contains(key) else { return nil }
        let container = try nestedContainer(keyedBy: type.CodingKeyType.self, forKey: key)
        return container.allKeys.isEmpty ? nil : try decode(T.self, forKey: key)
    }
}

struct DataResponseModel: Codable, EmptyDictionaryRepresentable{
    let title: String?
    let rows: [RowItem]?
    
    enum CodingKeys: String, CodingKey {
        case title, rows
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.rows = try container.decodeIfPresent([RowItem].self, forKey: .rows)
    }
}

struct RowItem: Codable, EmptyDictionaryRepresentable {
    
    let title: String?
    let description: String?
    let imageHref: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description, imageHref
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.imageHref = try container.decodeIfPresent(String.self, forKey: .imageHref)
    }
}
