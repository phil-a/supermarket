#### 🚀 Getting Started
To run the project locally, follow these steps:
Clone the repository:

```sh
git clone https://github.com/phil-a/supermarket
cd supermarket
```

Install dependencies:
`mix deps.get`

Run the tests: The project was developed with TDD. You can run the full test suite to verify all functionality is working as expected.
`mix test`

Run in an interactive Elixir session: You can experiment with the Checkout module directly using iex.
`iex -S mix`

#### Example usage:
```sh

# Get 
iex> items = [:GR1, :SR1, :GR1, :GR1, :CF1]
iex> Supermarket.Checkout.total(items)
Money.new(:GBP, "2245")


# Scan item
iex> checkout = Supermarket.Checkout.new()
iex> checkout = checkout |> Supermarket.Checkout.scan(:GR1)
iex> checkout = checkout |> Supermarket.Checkout.scan(:GR1)
iex> Supermarket.Checkout.format_receipt(checkout.items)
"Basket: CF1,CF1,CF1\nTotal price expected: £3.11"

```

#### Design choices
**Products**
  - represented as structs
  - holds code, name and price
  - compile-time checking

**Rules**
  - flexibility (stated that mind are changed often)
  - total takes list of items and applies rule functions to them
  - each rule is independent function
  - modular
  - active rules are managed in one place

**Test Driven Development**
  - provided framework for managing logic and complexity
  - living documentation

**Dependencies**
  - ex_money - Used for all monetary calculations and preventing rounding errors
  - ex_cldr - Backend for ex_money and formatting
  - dialyxir - static analysis tool, type specs
  - credo - consistent best practices, code smells
  - mix_test_watch - auto run tests
  - excoveralls - measures test coverage
  - ex_doc - documentation

#### Challenges

**Floating Point Rounding errors**
  - Handling currency - financial apps
  - Prices handled as integers and leveraged ex_money library
  - Completely avoids rounding errors
  - for the fractional discount, calculations performed on integer value and rounded at very last step for max precision

---

#### Future Improvements
  - Would modify it to use a GenServer - make checkout concurrent
  - Dynamically supervise Checkout
  - Refactor format function (leverage money formatting)
  


