*** Settings ***
Documentation       Product listing and inventory test suite for SauceDemo.
...                 Covers product count, sorting, cart operations, and product detail.
Resource            ../../resources/common.resource
Resource            ../../resources/login_page.resource
Resource            ../../resources/inventory_page.resource
Suite Setup         Run Keywords
...                 Open Browser To SauceDemo    AND
...                 Login As Standard User
Suite Teardown      Close Test Browser
Test Setup          Go To    ${BASE_URL}/inventory.html
Test Tags           shop    regression


*** Test Cases ***

TC-101 | Inventory Page Displays 6 Products
    [Documentation]    The product listing page must show exactly 6 inventory items.
    [Tags]              smoke
    Products Count Should Be    6

TC-102 | Sort Products By Price Low To High
    [Documentation]    Selecting lohi sort option must display prices in ascending order.
    Sort Products By    lohi
    Prices Should Be Sorted Low To High

TC-103 | Sort Products By Price High To Low
    [Documentation]    Selecting hilo sort option must display prices in descending order.
    Sort Products By    hilo
    Prices Should Be Sorted High To Low

TC-104 | Sort Products By Name A To Z
    [Documentation]    Selecting az sort option must display products alphabetically.
    Sort Products By    az
    # Verify no JS errors and sort dropdown reflects selection
    ${selected}=    Get Selected List Value    ${SORT_DROPDOWN}
    Should Be Equal    ${selected}    az

TC-105 | Add Single Item To Cart Increments Badge To 1
    [Documentation]    Adding one product must show badge count of 1.
    [Tags]              smoke
    Add Product To Cart    Sauce Labs Backpack
    Cart Badge Should Show    1

TC-106 | Add Multiple Items Updates Cart Badge
    [Documentation]    Adding three products must show badge count of 3.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Add Product To Cart    Sauce Labs Bolt T-Shirt
    Cart Badge Should Show    3

TC-107 | Product Detail Page Loads Correctly
    [Documentation]    Clicking a product name must navigate to the item detail page.
    Click On Product Name    Sauce Labs Backpack
    Location Should Contain    inventory-item.html
    Element Should Contain     ${ITEM_DETAIL_NAME}    Sauce Labs Backpack

TC-108 | Back To Products From Detail Page
    [Documentation]    The Back button on a product detail page must return to inventory.
    Click On Product Name    Sauce Labs Fleece Jacket
    Click Element    id:back-to-products
    Verify On Products Page
