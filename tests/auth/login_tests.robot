*** Settings ***
Documentation       Authentication test suite for SauceDemo.
...                 Covers valid login, invalid credentials, locked users,
...                 empty fields, logout, and page title validation.
Resource            ../../resources/common.resource
Resource            ../../resources/login_page.resource
Resource            ../../resources/inventory_page.resource
Suite Setup         Open Browser To SauceDemo
Suite Teardown      Close Test Browser
Test Setup          Navigate To Login Page
Test Tags           auth    regression


*** Test Cases ***

TC-001 | Valid Login Redirects To Products Page
    [Documentation]    Standard user should land on the Products page after login.
    [Tags]              smoke
    Submit Login        ${VALID_USER}    ${VALID_PASS}
    Verify On Products Page

TC-002 | Invalid Password Shows Error Message
    [Documentation]    Wrong password must show credential mismatch error.
    Submit Login        standard_user    wrong_password
    Login Error Should Be Visible    Username and password do not match

TC-003 | Locked Out User Sees Locked Error
    [Documentation]    Locked accounts must display the locked-out error message.
    Submit Login        ${LOCKED_USER}    ${VALID_PASS}
    Login Error Should Be Visible    Sorry, this user has been locked out

TC-004 | Empty Username Shows Validation Error
    [Documentation]    Clicking Login with no credentials must trigger validation.
    Click Login Button
    Login Error Should Be Visible    Username is required

TC-005 | Empty Password Shows Validation Error
    [Documentation]    Providing only a username and no password must trigger validation.
    Enter Username      standard_user
    Click Login Button
    Login Error Should Be Visible    Password is required

TC-006 | User Can Logout And Return To Login Page
    [Documentation]    Logged-in user must be able to logout via the burger menu.
    [Tags]              smoke
    Submit Login        ${VALID_USER}    ${VALID_PASS}
    Logout
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=10s
    Location Should Be               ${BASE_URL}/

    # ── ADD THIS LINE TO RESTORE THE STATE FOR THE NEXT TESTS ──
    #Submit Login        ${VALID_USER}    ${VALID_PASS}

    Wait Until Element Is Visible    ${LOGIN_BUTTON}


TC-007 | Login Page Has Correct Title
    [Documentation]    The login page logo text must read "Swag Labs".
    Login Page Title Should Be    Swag Labs
    Title Should Be               Swag Labs

TC-008 | Problem User Can Login Successfully
    [Documentation]    Problem user must be able to log in (UI bugs exist but login works).
    Submit Login        ${PROBLEM_USER}    ${VALID_PASS}
    Verify On Products Page
