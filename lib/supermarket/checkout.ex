defmodule Supermarket.Checkout do
  @moduledoc """
  The Checkout module handles the checkout process, applies pricing rules
  and calculating the total cost of items in the cart.
  """

  alias Supermarket.Product
  alias Supermarket.PricingRules.{BogoGreenTeaRule, ThreeOrMoreStrawberryRule, ThreeOrMoreCoffeeRule}

  # All current rules that are applied to the checkout process
  @rules [
    BogoGreenTeaRule,
    ThreeOrMoreStrawberryRule,
    ThreeOrMoreCoffeeRule
  ]

  @doc "Calculates the total cost of items in the cart."
  @spec total(list(atom)) :: Money.t()
  def total(items) do
    item_counts = Enum.frequencies(items)
    gross_total = calculate_gross_total(item_counts)
    total_discount = calculate_total_discount(item_counts)
    Money.sub!(gross_total, total_discount)
  end

  # Calculates the total cost of items in the cart
  defp calculate_gross_total(item_counts) do
    Enum.reduce(item_counts, Money.new(0, :GBP), fn {code, qty}, acc ->
      {:ok, %{price: price}} = Product.fetch(code)
      price_for_items = Money.mult!(price, qty)
      Money.add!(acc, price_for_items)
    end)
  end

  # Calculates the total discount based on the applied pricing rules.
  defp calculate_total_discount(item_counts) do
    Enum.reduce(@rules, Money.new(0, :GBP), fn rule_module, acc ->
      discount = rule_module.apply(item_counts)
      Money.add!(acc, discount)
    end)
  end
end
