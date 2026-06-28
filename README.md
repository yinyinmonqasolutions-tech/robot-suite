# 🤖 Robot Framework Suite

[![GitLab CI](https://img.shields.io/badge/GitLab_CI-passing-orange?logo=gitlab)](https://gitlab.com)
![Robot Framework](https://img.shields.io/badge/Robot_Framework-7.4.2-blue?logo=robot-framework)
![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)
![SeleniumLibrary](https://img.shields.io/badge/SeleniumLibrary-6.7.1-green)
![License](https://img.shields.io/badge/license-ISC-brightgreen)

Keyword-driven and data-driven **Robot Framework** automation suite with **SeleniumLibrary**, integrated into **GitLab CI/CD** for continuous regression execution — targeting [SauceDemo](https://www.saucedemo.com/) for UI tests and [JSONPlaceholder](https://jsonplaceholder.typicode.com/) for REST API tests.

---

## 📋 Table of Contents

- [About the Project](#about-the-project)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Test Coverage](#test-coverage)
- [GitLab CI/CD Pipeline](#gitlab-cicd-pipeline)
- [Test Credentials](#test-credentials)

---

## 📖 About the Project

This suite demonstrates enterprise-grade **keyword-driven** and **data-driven** test automation using Robot Framework. It is structured with a **Page Object Model** approach via `.resource` files, a custom Python keyword library, and a full **GitLab CI/CD** pipeline with parallel test stages and merged HTML reporting.

**Key features:**
- ✅ Keyword-driven design with reusable `.resource` page objects
- ✅ UI tests: authentication, product listing, sorting, cart, full checkout
- ✅ REST API tests: GET, POST, PUT, PATCH, DELETE, 404, response time
- ✅ Custom Python keyword library (`CustomKeywords.py`)
- ✅ Headless Chrome execution (configurable)
- ✅ Screenshot capture on test failure
- ✅ GitLab CI/CD — parallel stages for auth, shop, and API tests
- ✅ Merged HTML report (`rebot`) across all test stages
- ✅ Nightly scheduled run at 06:00 UTC (13:00 Bangkok ICT)

---

## 🛠 Tech Stack

| Tool | Version | Purpose |
|------|---------|---------|
| [Robot Framework](https://robotframework.org/) | `7.4.2` | Core test framework |
| [SeleniumLibrary](https://robotframework.org/SeleniumLibrary/) | `6.7.1` | Browser automation |
| [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/) | `0.9.7` | REST API testing |
| [DataDriver](https://github.com/Snooz82/robotframework-datadriver) | `1.11.1` | Data-driven testing |
| [Python](https://www.python.org/) | `3.12` | Runtime & custom keywords |
| [Selenium](https://pypi.org/project/selenium/) | `4.27.1` | WebDriver engine |
| [GitLab CI/CD](https://docs.gitlab.com/ee/ci/) | — | Pipeline & scheduling |

---

## 📁 Project Structure

```
robot-suite/
├── .gitlab-ci.yml                    # GitLab CI/CD pipeline (4 stages)
├── .gitignore
├── requirements.txt                  # Python dependencies
├── README.md
│
├── resources/                        # Page Object resource files
│   ├── common.resource               # Shared variables, browser setup, login keywords
│   ├── login_page.resource           # Login page locators & keywords
│   ├── inventory_page.resource       # Products page locators & keywords
│   └── checkout_page.resource        # Checkout pages locators & keywords
│
├── tests/
│   ├── auth/
│   │   └── login_tests.robot         # Authentication tests (TC-001 to TC-008)
│   ├── shop/
│   │   ├── product_listing_tests.robot  # Product listing tests (TC-101 to TC-108)
│   │   └── checkout_tests.robot         # Checkout flow tests (TC-201 to TC-207)
│   └── api/
│       └── jsonplaceholder_tests.robot  # REST API tests (TC-301 to TC-310)
│
├── data/
│   └── users.csv                     # Data-driven test data
│
├── libraries/
│   └── CustomKeywords.py             # Custom Python keyword library
│
└── reports/                          # Generated test reports (gitignored)
```

---

## ✅ Prerequisites

- [Python 3.12+](https://www.python.org/downloads/)
- [Google Chrome](https://www.google.com/chrome/) + matching [ChromeDriver](https://chromedriver.chromium.org/)
- [pip](https://pip.pypa.io/)
- [Git](https://git-scm.com/)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yinyinmonqasolutions-tech/robot-suite.git
cd robot-suite
```

### 2. Create a Virtual Environment

```bash
python -m venv venv
source venv/bin/activate        # macOS / Linux
venv\Scripts\activate           # Windows
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

---

## ▶️ Running Tests

### Run All Tests

```bash
robot --outputdir reports tests/
```

### Run a Specific Suite

```bash
robot --outputdir reports tests/auth/
robot --outputdir reports tests/shop/
robot --outputdir reports tests/api/
```

### Run by Tag

```bash
robot --include smoke --outputdir reports tests/
robot --include regression --outputdir reports tests/
robot --include api --outputdir reports tests/
robot --include e2e --outputdir reports tests/
```

### Run in Headed Mode (watch the browser)

```bash
robot --variable HEADLESS:False --outputdir reports tests/
```

### Override Credentials at Runtime

```bash
robot \
  --variable VALID_USER:standard_user \
  --variable VALID_PASS:secret_sauce \
  --outputdir reports tests/
```

### Merge Reports from All Stages

```bash
rebot --outputdir reports/merged \
      --name "Robot Framework Suite" \
      reports/auth/output.xml \
      reports/shop/output.xml \
      reports/api/output.xml
```

### View the Report

```bash
open reports/merged/report.html       # macOS
xdg-open reports/merged/report.html  # Linux
start reports/merged/report.html      # Windows
```

---

## 🧪 Test Coverage

### `tests/auth/login_tests.robot` — Authentication (8 tests)

| Test ID | Description | Tags |
|---------|-------------|------|
| TC-001 | Valid login redirects to Products page | smoke |
| TC-002 | Invalid password shows error message | regression |
| TC-003 | Locked-out user sees locked error | regression |
| TC-004 | Empty username shows validation error | regression |
| TC-005 | Empty password shows validation error | regression |
| TC-006 | User can logout and return to login page | smoke |
| TC-007 | Login page has correct title ("Swag Labs") | regression |
| TC-008 | Problem user can login successfully | regression |

---

### `tests/shop/product_listing_tests.robot` — Product Listing (8 tests)

| Test ID | Description | Tags |
|---------|-------------|------|
| TC-101 | Inventory page displays 6 products | smoke |
| TC-102 | Sort by price low to high | regression |
| TC-103 | Sort by price high to low | regression |
| TC-104 | Sort by name A to Z | regression |
| TC-105 | Add single item increments cart badge to 1 | smoke |
| TC-106 | Add 3 items updates cart badge to 3 | regression |
| TC-107 | Product detail page loads correctly | regression |
| TC-108 | Back to products from detail page | regression |

---

### `tests/shop/checkout_tests.robot` — Checkout Flow (7 tests)

| Test ID | Description | Tags |
|---------|-------------|------|
| TC-201 | Complete end-to-end checkout successfully | smoke, e2e |
| TC-202 | Checkout multiple items and verify total | regression |
| TC-203 | Checkout fails without first name | regression |
| TC-204 | Checkout fails without last name | regression |
| TC-205 | Checkout fails without postal code | regression |
| TC-206 | Remove item from cart clears badge | regression |
| TC-207 | Cancel checkout returns to inventory | regression |

---

### `tests/api/jsonplaceholder_tests.robot` — REST API (10 tests)

| Test ID | Method | Endpoint | Description | Tags |
|---------|--------|----------|-------------|------|
| TC-301 | GET | `/posts` | Returns 100 posts with correct schema | smoke |
| TC-302 | GET | `/posts/1` | Returns correct single post | regression |
| TC-303 | POST | `/posts` | Creates a new resource, returns 201 | smoke |
| TC-304 | PUT | `/posts/1` | Updates a post, returns 200 | regression |
| TC-305 | PATCH | `/posts/1` | Partially updates a post | regression |
| TC-306 | DELETE | `/posts/1` | Deletes a post, returns 200 | regression |
| TC-307 | GET | `/posts/9999` | Non-existent resource returns 404 | regression |
| TC-308 | GET | `/users` | Returns 10 users with email field | regression |
| TC-309 | GET | `/comments?postId=1` | Returns 5 comments for post 1 | regression |
| TC-310 | GET | `/posts` | Response time under 2000ms | performance |

**Total: 33 tests across 4 robot files**

---

## ⚡ GitLab CI/CD Pipeline

The pipeline at `.gitlab-ci.yml` has **4 stages**: `install → test (parallel) → report`

**Triggers:**
- Push to `main` or `develop`
- Merge request to `main`
- **Nightly schedule** at `06:00 UTC` (13:00 Bangkok ICT) — configure via GitLab → Settings → CI/CD → Schedules → `0 6 * * *`

**Jobs:**

| Job | Stage | Description |
|-----|-------|-------------|
| `install-dependencies` | install | Sets up venv, installs all pip dependencies |
| `test-auth` | test | Runs `tests/auth/` → artifacts in `reports/auth/` (7 days) |
| `test-shop` | test | Runs `tests/shop/` → artifacts in `reports/shop/` (7 days) |
| `test-api` | test | Runs `tests/api/` → artifacts in `reports/api/` (7 days) |
| `merge-reports` | report | Merges all `output.xml` with `rebot` → `reports/merged/` (30 days) |

### Setting GitLab CI/CD Variables

Go to **Settings → CI/CD → Variables** and add:

| Variable | Value |
|----------|-------|
| `SAUCEDEMO_USER` | `standard_user` |
| `SAUCEDEMO_PASS` | `secret_sauce` |

---

## 🔑 Test Credentials

| Username | Password | Used In |
|----------|----------|---------|
| `standard_user` | `secret_sauce` | TC-001, TC-101 to TC-108, TC-201 to TC-207 |
| `locked_out_user` | `secret_sauce` | TC-003 |
| `problem_user` | `secret_sauce` | TC-008 |

> Public demo credentials from [SauceDemo](https://www.saucedemo.com/) — safe to include here.

---

<p align="center">
  Built with ❤️ using <a href="https://robotframework.org/">Robot Framework</a>, <a href="https://robotframework.org/SeleniumLibrary/">SeleniumLibrary</a> & <a href="https://www.python.org/">Python</a>
</p>
