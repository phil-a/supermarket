defmodule Supermarket.Checkout do
  @moduledoc """
  The Checkout module handles the checkout process, applies pricing rules
  and calculating the total cost of items in the cart.
  """

  alias Supermarket.PricingRules.{BulkFixedDiscountRule, BulkFractionalDiscountRule, BuyOneGetOneFreeRule}
  alias Supermarket.Product

  @doc """
  Initialize the checkout.
  """
  def new do
    products = Product.all()

    pricing_rules = rules()

    %{
      products: products,
      pricing_rules: pricing_rules,
      items: []
    }
  end

  @doc """
  Scans an item and adds it to the checkout.
  """
  def scan(checkout, item) do
    if Map.has_key?(checkout.products, item) do
      %{checkout | items: [item | checkout.items]}
    else
      checkout
    end
  end

  @doc "Calculates the total cost of items in the cart."
  @spec total(list(atom)) :: Money.t()
  def total(items) do
    item_counts = Enum.frequencies(items)
    gross_total = calculate_gross_total(item_counts)
    total_discount = calculate_total_discount(item_counts)
    Money.sub!(gross_total, total_discount)
  end

  @doc "Formats the receipt for the items in the cart."
  # todo: remove hardcoded values + refactor this function to leverage money formatting
  def format_receipt(items) do
    basket_str = "Basket: #{Enum.join(items, ",")}"
    total_price_money = total(items)
    total_in_pence_decimal = Money.to_decimal(total_price_money)
    total_in_pence_integer = Decimal.to_integer(total_in_pence_decimal)

    pounds = div(total_in_pence_integer, 100)
    pence = rem(total_in_pence_integer, 100)

    formatted_price = "£#{pounds}.#{String.pad_leading("#{pence}", 2, "0")}"

    total_str = "Total price expected: #{formatted_price}"

    IO.puts("#{basket_str}\n#{total_str}")
  end

  # Calculates the gross total price before discounts applied.
  defp calculate_gross_total(item_counts) do
    Enum.reduce(item_counts, Money.new(0, :GBP), fn {product_code, quantity}, acc ->
      price = Product.get_price(product_code)
      line_total = Money.mult!(price, quantity)
      Money.add!(acc, line_total)
    end)
  end

  # Calculates the total discount based on the applied pricing rules.
  defp calculate_total_discount(item_counts) do
    Enum.reduce(rules(), Money.new(0, :GBP), fn rule, acc ->
      discount = rule.__struct__.apply(rule, item_counts)
      Money.add!(acc, discount)
    end)
  end

  # all active pricing rules as structs
  defp rules do
    [
      %BuyOneGetOneFreeRule{product_code: :GR1},
      %BulkFixedDiscountRule{
        product_code: :SR1,
        min_quantity: 3,
        new_price: Money.new(450, :GBP)
      },
      %BulkFractionalDiscountRule{
        product_code: :CF1,
        min_quantity: 3,
        price_fraction: {2, 3} # numerator, denominator
      }
    ]
  end
end
