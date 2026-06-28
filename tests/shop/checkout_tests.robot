*** Settings ***
Documentation       Checkout flow test suite for SauceDemo.
...                 Covers end-to-end purchase, cart removal, and validation errors.
Resource            ../../resources/common.resource
Resource            ../../resources/login_page.resource
Resource            ../../resources/inventory_page.resource
Resource            ../../resources/checkout_page.resource
Suite Setup         Run Keywords
...                 Open Browser To SauceDemo    AND
...                 Login As Standard User
Suite Teardown      Close Test Browser
Test Setup          Reset Shop State
Test Tags           shop    regression


*** Test Cases ***

TC-201 | Complete End-To-End Checkout Successfully
    [Documentation]    Full happy path: add item → cart → shipping info → order complete.
    [Tags]              smoke    e2e
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Cart Should Have Items    1
    Proceed To Checkout
    Fill Shipping Information
    Element Should Be Visible    ${CHECKOUT_TOTAL_LABEL}
    Complete Order
    Location Should Contain      /checkout-complete.html

TC-202 | Checkout Multiple Items And Verify Total
    [Documentation]    Add two items, proceed to checkout, and verify summary is visible.
    Add Product To Cart    Sauce Labs Backpack
    Add Product To Cart    Sauce Labs Bike Light
    Cart Badge Should Show    2
    Go To Cart
    Cart Should Have Items    2
    Proceed To Checkout
    Fill Shipping Information
    Element Should Be Visible    ${CHECKOUT_SUMMARY}
    Element Should Be Visible    ${CHECKOUT_TOTAL_LABEL}
    Complete Order

TC-203 | Checkout Fails Without First Name
    [Documentation]    Submitting checkout without a first name must show validation error.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Proceed To Checkout
    # Leave first name empty — fill only last name and postal code
    Input Text      ${CHECKOUT_LASTNAME}    Yin
    Input Text      ${CHECKOUT_POSTAL}      11100
    Click Element   ${CHECKOUT_CONTINUE}
    Checkout Error Should Contain    First Name is required

TC-204 | Checkout Fails Without Last Name
    [Documentation]    Submitting checkout without a last name must show validation error.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Proceed To Checkout
    Input Text      ${CHECKOUT_FIRSTNAME}    Yin
    Input Text      ${CHECKOUT_POSTAL}       11100
    Click Element   ${CHECKOUT_CONTINUE}
    Checkout Error Should Contain    Last Name is required

TC-205 | Checkout Fails Without Postal Code
    [Documentation]    Submitting checkout without a postal code must show validation error.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Proceed To Checkout
    Input Text      ${CHECKOUT_FIRSTNAME}    Yin
    Input Text      ${CHECKOUT_LASTNAME}     Yin
    Click Element   ${CHECKOUT_CONTINUE}
    Checkout Error Should Contain    Postal Code is required

TC-206 | Remove Item From Cart Clears Badge
    [Documentation]    Removing the only cart item must hide the cart badge.
    Add Product To Cart    Sauce Labs Backpack
    Cart Badge Should Show    1
    Go To Cart
    Remove Item From Cart    remove-sauce-labs-backpack
    Page Should Not Contain Element    css:.cart_item
    Page Should Not Contain Element    ${CART_BADGE}

TC-207 | Cancel Checkout Returns To Inventory
    [Documentation]    Clicking Cancel on checkout step 1 must return to inventory.
    Add Product To Cart    Sauce Labs Backpack
    Go To Cart
    Proceed To Checkout
    Click Element    id:cancel
    Verify On Products Page
