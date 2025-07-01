defmodule Supermarket.Product do
  @moduledoc "Defines the product catalog and provides a lookup function."

  @products %{
    gr1: %{name: "Green tea", price: Money.new(311, :GBP)},
    sr1: %{name: "Strawberries", price: Money.new(500, :GBP)},
    cf1: %{name: "Coffee", price: Money.new(1123, :GBP)}
  }

  @spec fetch(atom) :: {:ok, map()} | :error
  def fetch(product_code), do: Map.fetch(@products, product_code)
end
