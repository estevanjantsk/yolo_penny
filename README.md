# YoloPenny

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# yolo_penny
# yolo_penny

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