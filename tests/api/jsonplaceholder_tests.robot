*** Settings ***
Documentation       REST API test suite using JSONPlaceholder as the target API.
...                 Covers GET, POST, PUT, DELETE, 404 handling, and response time.
...                 Uses keyword-driven and data-driven approaches.
Library             RequestsLibrary
Library             Collections
Library             String
Test Tags           api    regression


*** Variables ***
${API_BASE}             https://jsonplaceholder.typicode.com
${EXPECTED_POST_COUNT}  ${100}
${MAX_RESPONSE_MS}      ${2000}


*** Test Cases ***

TC-301 | GET /posts Returns 100 Posts With Correct Schema
    [Documentation]    GET all posts must return 200 with 100 items and correct schema keys.
    [Tags]              smoke
    ${response}=    GET    ${API_BASE}/posts    expected_status=200
    ${body}=        Set Variable    ${response.json()}
    Length Should Be    ${body}    ${EXPECTED_POST_COUNT}
    Dictionary Should Contain Key    ${body}[0]    userId
    Dictionary Should Contain Key    ${body}[0]    id
    Dictionary Should Contain Key    ${body}[0]    title
    Dictionary Should Contain Key    ${body}[0]    body

TC-302 | GET /posts/1 Returns Correct Single Post
    [Documentation]    GET a single post must return 200 and id equal to 1.
    ${response}=    GET    ${API_BASE}/posts/1    expected_status=200
    ${post}=        Set Variable    ${response.json()}
    Should Be Equal As Integers    ${post}[id]      1
    Should Be True                 len('${post}[title]') > 0

TC-303 | POST /posts Creates A New Resource
    [Documentation]    POST a new post must return 201 and the created object with an id.
    [Tags]              smoke
    ${payload}=    Create Dictionary
    ...    title=Robot Framework API Test
    ...    body=Automated by YinYinMon
    ...    userId=${1}
    ${response}=    POST    ${API_BASE}/posts
    ...    json=${payload}
    ...    expected_status=201
    ${created}=     Set Variable    ${response.json()}
    Should Be Equal    ${created}[title]    Robot Framework API Test
    Dictionary Should Contain Key    ${created}    id

TC-304 | PUT /posts/1 Updates An Existing Post
    [Documentation]    PUT must replace post 1 and return 200 with updated title.
    ${payload}=    Create Dictionary
    ...    id=${1}
    ...    title=Updated Title
    ...    body=Updated body content
    ...    userId=${1}
    ${response}=    PUT    ${API_BASE}/posts/1
    ...    json=${payload}
    ...    expected_status=200
    ${updated}=     Set Variable    ${response.json()}
    Should Be Equal    ${updated}[title]    Updated Title

TC-305 | PATCH /posts/1 Partially Updates A Post
    [Documentation]    PATCH must partially update post 1 and return 200.
    ${payload}=    Create Dictionary    title=Patched Title
    ${response}=    PATCH    ${API_BASE}/posts/1
    ...    json=${payload}
    ...    expected_status=200
    ${patched}=     Set Variable    ${response.json()}
    Should Be Equal    ${patched}[title]    Patched Title

TC-306 | DELETE /posts/1 Returns 200
    [Documentation]    DELETE post 1 must return status 200.
    ${response}=    DELETE    ${API_BASE}/posts/1    expected_status=200

TC-307 | GET /posts/9999 Returns 404 For Non-Existent Resource
    [Documentation]    Requesting a non-existent post must return 404.
    ${response}=    GET    ${API_BASE}/posts/9999    expected_status=404

TC-308 | GET /users Returns 10 Users
    [Documentation]    GET all users must return 200 with exactly 10 user records.
    ${response}=    GET    ${API_BASE}/users    expected_status=200
    ${body}=        Set Variable    ${response.json()}
    Length Should Be    ${body}    10
    Dictionary Should Contain Key    ${body}[0]    email

TC-309 | GET /comments?postId=1 Returns Comments For Post
    [Documentation]    Filter comments by postId=1 must return 5 comments.
    ${params}=      Create Dictionary    postId=1
    ${response}=    GET    ${API_BASE}/comments    params=${params}    expected_status=200
    ${body}=        Set Variable    ${response.json()}
    Length Should Be    ${body}    5
    Should Be Equal As Integers    ${body}[0][postId]    1

TC-310 | API Response Time Is Under 2 Seconds
    [Documentation]    The /posts endpoint must respond within 2000ms.
    [Tags]              performance
    ${response}=    GET    ${API_BASE}/posts    expected_status=200
    ${elapsed_ms}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Should Be True    ${elapsed_ms} < ${MAX_RESPONSE_MS}
    ...    msg=Response time ${elapsed_ms}ms exceeded ${MAX_RESPONSE_MS}ms limit
