*** Settings ***
Documentation       Common settings, variables, and keywords shared across all test suites.
Library             SeleniumLibrary
Library             Collections
Library             String
Library             OperatingSystem

# This safely assigns the screenshot step to every single test case automatically!
#Test Teardown       Capture Screenshot If Test Failed


*** Variables ***
# ── Application URLs ─────────────────────────────────────────────
${BASE_URL}             https://www.saucedemo.com
${API_URL}              https://jsonplaceholder.typicode.com

# ── Browser & Timing ─────────────────────────────────────────────
${BROWSER}              chrome
${HEADLESS}             ${FALSE}    # Set to ${FALSE} if you want to watch the actual UI windows pop up!
${IMPLICIT_WAIT}        8s
${PAGE_LOAD_TIMEOUT}    30s

# ── Credentials (override via env or CLI --variable) ─────────────
${VALID_USER}           standard_user
${VALID_PASS}           secret_sauce
${LOCKED_USER}          locked_out_user
${PROBLEM_USER}         problem_user

# ── Shipping Data ─────────────────────────────────────────────────
${FIRST_NAME}           Yin
${LAST_NAME}            Yin
${POSTAL_CODE}          11100


*** Keywords ***
# ── Browser Setup / Teardown ──────────────────────────────────────
Open Browser To SauceDemo
    [Documentation]    Opens Chrome maximized at 67% zoom and bypasses all password popup vectors.
    ${options}=         Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Run Keyword If      ${HEADLESS}    Call Method    ${options}    add_argument    --headless
    Call Method         ${options}    add_argument    --no-sandbox
    Call Method         ${options}    add_argument    --disable-dev-shm-usage
    Call Method         ${options}    add_argument    --disable-gpu

    # ── MAXIMIZE WINDOW AND SET 67% ZOOM ──────────────────────────────────
    Call Method         ${options}    add_argument    --start-maximized
    Call Method         ${options}    add_argument    --force-device-scale-factor\=0.67

    # ── CRITICAL: BLOCKS PASSWORD DATA BREACH ALERT COMPLETELY ────────────
    Call Method         ${options}    add_argument    --disable-features\=LeakDetection,PasswordLeakDetection,SafeBrowsingPasswordProtection
    Call Method         ${options}    add_argument    --disable-component-update
    # ───────────────────────────────────────────────────────────────────────

    # Heavy preference layer to ensure browser-side managers remain dead
    ${prefs}=           Create Dictionary
    ...                 credentials_enable_service=${FALSE}
    ...                 profile.password_manager_enabled=${FALSE}
    ...                 password_manager_leak_detection=${FALSE}
    ...                 profile.password_manager_leak_detection=${FALSE}
    Call Method         ${options}    add_experimental_option    prefs    ${prefs}

    Open Browser        ${BASE_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Set Selenium Page Load Timeout    ${PAGE_LOAD_TIMEOUT}

Capture Screenshot If Test Failed
    [Documentation]    Safe wrapper meant strictly for individual test structures.
    Run Keyword If Test Failed    Capture Page Screenshot    reports/failure_\${TEST_NAME}.png

Close Test Browser
    [Documentation]    Safe to run at suite level now because the test-status logic is separated.
    Close Browser

# ── Login / Logout ────────────────────────────────────────────────
Login As
    [Documentation]    Logs into SauceDemo with the provided username and password.
    [Arguments]         ${username}    ${password}
    Go To               ${BASE_URL}
    Wait Until Element Is Visible    id:user-name    timeout=10s
    Input Text          id:user-name    ${username}
    Input Text          id:password     ${password}
    Click Button        id:login-button

Login As Standard User
    [Documentation]    Logs in with the standard valid user.
    Login As            ${VALID_USER}    ${VALID_PASS}
    Wait Until Element Is Visible    css:.title    timeout=10s
    Element Text Should Be           css:.title    Products

Logout
    [Documentation]    Clears any stubborn Chrome password alerts using Escape,
    ...                then logs out smoothly via the sidebar.

    # Press Escape twice to dismiss Chrome's security alert modal cleanly
    Press Keys          None    ESC
    Sleep               0.5s
    Press Keys          None    ESC

    # Now interact with the menu safely
    Wait Until Element Is Visible    id:react-burger-menu-btn    timeout=10s
    Click Element                    id:react-burger-menu-btn

    Wait Until Element Is Visible    id:logout_sidebar_link    timeout=10s
    Wait Until Element Is Enabled    id:logout_sidebar_link    timeout=5s
    Click Element                    id:logout_sidebar_link

    Wait Until Element Is Visible    id:login-button    timeout=15s

# ── Assertions ────────────────────────────────────────────────────
Page Should Show Error
    [Documentation]    Asserts that the SauceDemo error banner is visible and contains expected text.
    [Arguments]         ${expected_text}
    Wait Until Element Is Visible    css:[data-test="error"]    timeout=5s
    Element Should Contain           css:[data-test="error"]    ${expected_text}