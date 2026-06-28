*** Settings ***
Documentation       Page Object keywords for the SauceDemo Checkout pages.
Library             SeleniumLibrary
Resource            ../resources/common.resource

*** Variables ***
# ── Step 1: Your Information ───────────────────────────────────────
${CHECKOUT_FIRSTNAME}       id:first-name
${CHECKOUT_LASTNAME}        id:last-name
${CHECKOUT_POSTAL}          id:postal-code
${CHECKOUT_CONTINUE}        id:continue
${CHECKOUT_ERROR}           css:[data-test="error"]

# ── Step 2: Overview ──────────────────────────────────────────────
${CHECKOUT_SUMMARY}         css:.summary_info
${CHECKOUT_TOTAL_LABEL}     css:.summary_total_label
${CHECKOUT_FINISH}          id:finish

# ── Step 3: Complete ──────────────────────────────────────────────
${ORDER_COMPLETE_HEADER}    css:.complete-header
${ORDER_COMPLETE_TEXT}      css:.complete-text

# ── Cart ──────────────────────────────────────────────────────────
${CART_CHECKOUT_BTN}        id:checkout
${CART_ITEMS}               css:.cart_item
${REMOVE_BACKPACK_BTN}      id:remove-sauce-labs-backpack


*** Keywords ***
Proceed To Checkout
    [Documentation]    Ensures the checkout button is interactable before clicking.
    Wait Until Element Is Visible    ${CART_CHECKOUT_BTN}    timeout=15s
    Wait Until Element Is Enabled    ${CART_CHECKOUT_BTN}    timeout=10s

    # Using Click Button is much more stable for <button> HTML tags
    Click Button                     ${CART_CHECKOUT_BTN}

     ${url}=    Get Location

    Log To Console    Current URL = ${url}


    Wait Until Element Is Visible
    ...    ${CHECKOUT_FIRSTNAME}

    # Wait for the next page's input fields to fully load
    Wait Until Element Is Visible    ${CHECKOUT_FIRSTNAME}   timeout=30s

Fill Shipping Information
    [Documentation]    Fills in the shipping form and clicks Continue.
    [Arguments]         ${first_name}=${FIRST_NAME}    ${last_name}=${LAST_NAME}    ${postal}=${POSTAL_CODE}
    Wait Until Element Is Visible    ${CHECKOUT_FIRSTNAME}   timeout=10s
    Input Text          ${CHECKOUT_FIRSTNAME}    ${first_name}
    Input Text          ${CHECKOUT_LASTNAME}     ${last_name}
    Input Text          ${CHECKOUT_POSTAL}       ${postal}

    # Wait until continue button is clickable, then press it
    Wait Until Element Is Enabled    ${CHECKOUT_CONTINUE}    timeout=5s
    Click Button        ${CHECKOUT_CONTINUE}
    Wait Until Element Is Visible    ${CHECKOUT_SUMMARY}    timeout=15s

Complete Order
    [Documentation]    Clicks Finish and asserts order completion.
    Wait Until Element Is Visible    ${CHECKOUT_FINISH}    timeout=5s
    Click Element                    ${CHECKOUT_FINISH}
    Wait Until Element Is Visible    ${ORDER_COMPLETE_HEADER}    timeout=10s
    Element Should Contain           ${ORDER_COMPLETE_HEADER}    Thank you

Cart Should Have Items
    [Arguments]         ${expected_count}
    ${items}=    Get WebElements    ${CART_ITEMS}
    Length Should Be    ${items}    ${expected_count}

Checkout Error Should Contain
    [Arguments]         ${expected_text}
    Wait Until Element Is Visible    ${CHECKOUT_ERROR}    timeout=5s
    Element Should Contain           ${CHECKOUT_ERROR}    ${expected_text}

Remove Item From Cart
    [Arguments]         ${remove_btn_id}
    Click Element       id:${remove_btn_id}

Reset Shop State
    Go To    ${BASE_URL}/inventory.html

    ${buttons}=    Get WebElements
    ...    xpath://button[contains(@id,'remove')]

    FOR    ${btn}    IN    @{buttons}
        Click Element    ${btn}
    END