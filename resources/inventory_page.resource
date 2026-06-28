*** Settings ***
Documentation       Page Object keywords for the SauceDemo Inventory (Products) page.
Library             SeleniumLibrary
Library             Collections


*** Variables ***
# ── Locators ──────────────────────────────────────────────────────
${INVENTORY_TITLE}          css:.title
${INVENTORY_ITEMS}          css:.inventory_item
${SORT_DROPDOWN}            css:.product_sort_container
${CART_BADGE}               css:.shopping_cart_badge
${CART_LINK}                css:.shopping_cart_link
${ITEM_PRICES}              css:.inventory_item_price
${ITEM_DETAIL_NAME}         css:.inventory_details_name


*** Keywords ***
Verify On Products Page
    [Documentation]    Asserts URL contains /inventory.html and title is "Products".
    Wait Until Element Is Visible    ${INVENTORY_TITLE}    timeout=10s
    Element Text Should Be           ${INVENTORY_TITLE}    Products
    Location Should Contain          /inventory.html

Products Count Should Be
    [Documentation]    Asserts the total number of product cards displayed.
    [Arguments]         ${expected_count}
    ${items}=    Get WebElements    ${INVENTORY_ITEMS}
    Length Should Be    ${items}    ${expected_count}

Add Product To Cart
    [Documentation]    Clicks the "Add to cart" button for a product matching the given name.
    [Arguments]         ${product_name}
    ${button}=  Get WebElement    xpath://div[contains(@class,'inventory_item_name') and contains(text(),'${product_name}')]/ancestor::div[@class='inventory_item']//button[contains(@id,'add-to-cart')]

    Wait Until Element Is Visible    ${button}    timeout=10s
    Wait Until Element Is Enabled    ${button}    timeout=5s
    Click Element    ${button}

Cart Badge Should Show
    [Documentation]    Asserts the cart badge number equals the expected count.
    [Arguments]         ${expected_count}
    Wait Until Element Is Visible    ${CART_BADGE}    timeout=15s
    Element Text Should Be           ${CART_BADGE}    ${expected_count}

Sort Products By
    [Documentation]    Selects a sort option from the dropdown. Options: az, za, lohi, hilo
    [Arguments]         ${option}
    Select From List By Value    ${SORT_DROPDOWN}    ${option}

Get All Prices As Numbers
    [Documentation]    Returns a list of product prices (float) from the inventory page.
    ${price_elements}=    Get WebElements    ${ITEM_PRICES}
    ${prices}=    Create List
    FOR    ${el}    IN    @{price_elements}
        ${text}=    Get Text    ${el}
        ${num}=    Evaluate    float('${text}'.replace('$','').strip())
        Append To List    ${prices}    ${num}
    END
    RETURN    ${prices}

Prices Should Be Sorted Low To High
    [Documentation]    Asserts that prices are in ascending order.
    ${prices}=    Get All Prices As Numbers
    ${sorted}=    Evaluate    sorted(${prices})
    Lists Should Be Equal    ${prices}    ${sorted}

Prices Should Be Sorted High To Low
    [Documentation]    Asserts that prices are in descending order.
    ${prices}=    Get All Prices As Numbers
    ${sorted}=    Evaluate    sorted(${prices}, reverse=True)
    Lists Should Be Equal    ${prices}    ${sorted}

Go To Cart
    Click Element    ${CART_LINK}
    Wait Until Element Is Visible    css:.cart_list    timeout=10s

Click On Product Name
    [Arguments]    ${product_name}
    Click Element    xpath://div[@class='inventory_item_name' and text()='${product_name}']
    Wait Until Element Is Visible    ${ITEM_DETAIL_NAME}    timeout=10s
