//
//  CategoryQuoteMapperSpec.swift
//  KarhooSDKTests
//
//  
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooSDK

final class CategoryQuoteMapperSpec: XCTestCase {

    private var testObject: CategoryQuoteMapper!

    override func setUp() {
        super.setUp()

        testObject = CategoryQuoteMapper()
    }

    /**
      * When: Passinng in an array of categories
      * And: An array of quotes with exact matching categories
      * Then: The expected dictionary should be outputted
      */
    func testMatchingCategoriesAndQuotesMapCorrectly() {
        let mockCategories = CategoriesMock().set(categories: ["foo", "bar", "fizz"]).build()

        var mockQuotes: [Quote] = []
        mockQuotes.append(QuoteMock().set(quoteId: "fooQuote").set(categoryName: "foo").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())
        mockQuotes.append(QuoteMock().set(quoteId: "fizzQuote").set(categoryName: "fizz").build())

        let expectedOutput = testObject.map(categories: mockCategories.categories, toQuotes: mockQuotes)

        let fooQuotes = expectedOutput.first(where: { $0.categoryName == "foo"})?.quotes
        let barQuotes = expectedOutput.first(where: { $0.categoryName == "bar"})?.quotes
        let fizzQuotes = expectedOutput.first(where: { $0.categoryName == "fizz"})?.quotes

        XCTAssertEqual(mockQuotes[0].id, fooQuotes?[0].id)
        XCTAssertEqual(mockQuotes[1].id, barQuotes?[0].id)
        XCTAssertEqual(mockQuotes[2].id, fizzQuotes?[0].id)
    }

    /**
     * When: Passinng in an array of categories
     * And: An array of quotes that has one mismatched category
     * Then: The expected dictionary should be outputted
     * And: The mismatched category quotes should be nil
     */
    func testMismatchedCategoryNameMapsCorrectly() {
        let mockCategories = CategoriesMock().set(categories: ["foo", "bar", "rogue-category"]).build()

        var mockQuotes: [Quote] = []
        mockQuotes.append(QuoteMock().set(quoteId: "fooQuote").set(categoryName: "foo").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())

        let expectedOutput = testObject.map(categories: mockCategories.categories, toQuotes: mockQuotes)

        let fooQuotes = expectedOutput.first(where: { $0.categoryName == "foo"})?.quotes
        let barQuotes = expectedOutput.first(where: { $0.categoryName == "bar"})?.quotes
        let rogueCategoryQuotes = expectedOutput.first(where: { $0.categoryName == "rogue-category"})?.quotes

        XCTAssertEqual(1, fooQuotes?.count)
        XCTAssertEqual(2, barQuotes?.count)
        XCTAssertTrue(rogueCategoryQuotes!.isEmpty)
    }

    /**
      * When: Passing an array of categories
      * And: There is a duplicate category
      * Then: There should only be 2 categories outputted (removes duplicate foo)
      */
    func testDuplicateCategoryHandling() {
        let mockCategories = CategoriesMock().set(categories: ["foo", "bar", "foo"]).build()

        var mockQuotes: [Quote] = []
        mockQuotes.append(QuoteMock().set(quoteId: "fooQuote").set(categoryName: "foo").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())

        let expectedOutput = testObject.map(categories: mockCategories.categories, toQuotes: mockQuotes)

        XCTAssertEqual(2, expectedOutput.count)
    }

    /**
      * When: Passing nil categories
      * Then: Quotes should be categorized by their category names only
      */
    func testNilCategoriesMapsValidQuotesCorrectly() {
        var mockQuotes: [Quote] = []
        mockQuotes.append(QuoteMock().set(quoteId: "fooQuote").set(categoryName: "foo").build())
        mockQuotes.append(QuoteMock().set(quoteId: "barQuote").set(categoryName: "bar").build())
        mockQuotes.append(QuoteMock().set(quoteId: "fizzQuote").set(categoryName: "fizz").build())

        let expectedOutput = testObject.map(categories: [], toQuotes: mockQuotes)

        let fooQuotes = expectedOutput.first(where: { $0.categoryName == "foo"})?.quotes
        let barQuotes = expectedOutput.first(where: { $0.categoryName == "bar"})?.quotes
        let fizzQuotes = expectedOutput.first(where: { $0.categoryName == "fizz"})?.quotes

        XCTAssertEqual(mockQuotes[0].id, fooQuotes![0].id)
        XCTAssertEqual(mockQuotes[1].id, barQuotes![0].id)
        XCTAssertEqual(mockQuotes[2].id, fizzQuotes![0].id)
    }
}
