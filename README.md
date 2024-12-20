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
- [ ] Users Authentication
- [ ] Expense Management
- [ ] Cover with tests

## GitHub Actions Workflow for Elixir CI

The GitHub Actions workflow I added is designed to automate the Continuous Integration (CI) process for an Elixir project. It includes several jobs to ensure code quality, security, and correctness.

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

This workflow ensures that your Elixir project is consistently checked for code quality, security, and correctness on every pull request.
