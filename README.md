# Test Task for Elixir LiveView Developers

Build a simple expense tracker application using Phoenix LiveView. The application should allow users to log in with a unique username, add expense entries, and see real-time updates.

---

## Requirements

- **Code Management and Setup**
  - All code should be shared via GitHub repository.
  - The solution should be built with Phoenix LiveView.
  - The solution should manage data in memory. **No database** should be used.
  - You are free to use any Elixir/Erlang library and any open-source CSS framework for the design.

- **User Authentication**
  - Users should be able to log in by entering a unique username.
  - No complex authentication is required; a simple unique username is sufficient.

- **Expense Management**
  - Users should be able to add new expenses with the following fields:
    - **Amount** (numeric, required)
    - **Date** (defaults to today’s date if not specified)
    - **Description** (optional)
  - Each user should only see their own expenses.
  - It should be possible to open the same user’s ledger in multiple tabs and see real-time updates across all tabs.

---

## Deliverables

Please provide a link to a GitHub repository containing your solution to the above task. Your solution should include:

- A Phoenix LiveView application that meets the above requirements.
- A `README.md` file that explains how to set up and run the application.
- Clear and concise documentation on how the application works, including any design decisions and trade-offs.
- Well-structured, maintainable code that adheres to best practices.
- Tests covering the core functionality of the application.

---

## Evaluation Criteria

Your solution will be evaluated based on the following criteria:

- **Functionality**: Does the application meet all requirements?
- **Code Quality**: Is the code well-structured, maintainable, and easy to understand? Does it follow best practices?
- **Design Decisions**: Were thoughtful design decisions made? Were trade-offs considered and explained?
- **Documentation**: Is the `README.md` file clear, comprehensive, and does it include instructions for setup and usage? Does the documentation provide insight into design decisions?
- **Testing**: Does the solution include tests that cover the core functionality?

Good luck! We look forward to seeing your solution.

---

# YoloPenny

### TODO
- [x] Add CI Pipeline
- [x] Users Authentication
- [x] Expense Management
- [x] Realtime updates
- [x] Cover with tests

---

## How to run

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Main endpoints:

sign in: ``localhost:4000/users/log_in`

sign up: `localhost:4000/users/register"`

dashboard: `localhost:4000/dashboard`

new expense: `localhost:4000/dashboard/new-expense`

## Solution Overview
Using a GenServer for managing user data and expense management in memory is a suitable choice for the following reasons:

- **Concurrent Data Management**: GenServers can handle state and perform operations concurrently, making them ideal for managing user-specific data in a real-time application.
- **Real-Time Updates**: Since Phoenix LiveView works with real-time WebSocket connections, a GenServer can notify connected processes (tabs) of any state changes, ensuring synchronization.
- **Isolation of Data:**: By structuring the state to associate expenses with specific users, we ensure data integrity and security—each user only accesses their own data.
- **In-Memory Speed**: As there's no database involved, a GenServer provides quick access to state stored in memory.

### GitHub Actions Workflow for Elixir CI

The GitHub Actions workflow I added is designed to automate the Continuous Integration (CI) process for an Elixir project. It includes several jobs to ensure code quality, security, and correctness.

<img width="1413" alt="image" src="https://github.com/user-attachments/assets/a8ed86e0-9bbb-47bb-8ddd-f05093d5e24b" />

### Workflow Overview

- **Trigger**: The workflow is triggered on pull requests to the `main` branch.
- **Environment Variables**: 
  - `MIX_ENV`: Set to `test`.
  - `ELIXIR`: Set to `1.16.1`.
  - `OTP`: Set to `26`.

### Jobs

1. **Compile**:
   - **Purpose**: Install dependencies and compile the project.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Install Mix dependencies.
     - Compile the project without warnings.
     - Save dependencies cache.

2. **Format**:
   - **Purpose**: Check code formatting.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Run `mix format --check-formatted`.

3. **Credo**:
   - **Purpose**: Check code style using Credo.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Run `mix credo --strict`.

4. **Dialyzer**:
   - **Purpose**: Perform static analysis using Dialyzer.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Restore PLT cache.
     - Create PLTs.
     - Run Dialyzer.
     - Save PLT cache.

5. **Sobelow**:
   - **Purpose**: Check for security issues using Sobelow.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Run `mix sobelow --config`.

6. **Test**:
   - **Purpose**: Run tests.
   - **Steps**:
     - Checkout the code.
     - Set up Elixir and Erlang/OTP.
     - Restore dependencies cache.
     - Run tests using `mix test`.

### Caching

- **Dependencies Cache**: Caches the `_build` and `deps` directories to speed up subsequent runs.
- **PLT Cache**: Caches the Dialyzer PLTs to avoid rebuilding them every time.

### Tests

For the tests, I focused on the 80/20 rule, prioritizing the most critical areas. Specifically, I covered both GenServers (Users and Expenses), the entire user authentication process, and in LiveView, I tested a complete flow—from creating and listing an expense to deleting it.
