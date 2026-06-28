*** Settings ***
Documentation       Page Object keywords for the SauceDemo Login page.
Library             SeleniumLibrary
Resource            ../resources/common.resource

*** Variables ***
# ── Locators ──────────────────────────────────────────────────────
${LOGIN_USERNAME_INPUT}     id:user-name
${LOGIN_PASSWORD_INPUT}     id:password
${LOGIN_BUTTON}             id:login-button
${LOGIN_ERROR_MSG}          css:[data-test="error"]
${LOGIN_LOGO}               css:.login_logo


*** Keywords ***
Navigate To Login Page
    [Documentation]    Navigates directly to the SauceDemo login page.
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    ${LOGIN_USERNAME_INPUT}    timeout=10s

Enter Username
    [Arguments]         ${username}
    Clear Element Text  ${LOGIN_USERNAME_INPUT}
    Input Text          ${LOGIN_USERNAME_INPUT}    ${username}

Enter Password
    [Arguments]         ${password}
    Clear Element Text  ${LOGIN_PASSWORD_INPUT}
    Input Text          ${LOGIN_PASSWORD_INPUT}    ${password}

Click Login Button
    Click Button    ${LOGIN_BUTTON}

Submit Login
    [Documentation]    Fills in credentials and clicks login.
    [Arguments]         ${username}    ${password}
    Enter Username      ${username}
    Enter Password      ${password}
    Click Login Button

Login Error Should Be Visible
    [Arguments]         ${expected_message}
    Wait Until Element Is Visible    ${LOGIN_ERROR_MSG}    timeout=5s
    Element Should Contain           ${LOGIN_ERROR_MSG}    ${expected_message}

Login Page Title Should Be
    [Arguments]         ${expected_title}
    Element Should Contain    ${LOGIN_LOGO}    ${expected_title}
