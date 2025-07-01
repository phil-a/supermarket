defmodule Supermarket.Product do
  @moduledoc "Defines the product structure and products."
  defstruct [:code, :name, :price]

  @doc "Returns a map of all products."
  def all do
    products_data()
  end

  @doc """
  Finds the price for a given product code.

  Raises an error if the product code does not exist.
  """
  @spec get_price(atom()) :: Money.t()
  def get_price(product_code) do
    product = Map.fetch!(products_data(), product_code)
    product.price
  end

  # function holds our data, to be swapped by a database or external service later.
  defp products_data do
    %{
      GR1: %__MODULE__{code: :GR1, name: "Green Tea", price: Money.new(311, :GBP)},
      SR1: %__MODULE__{code: :SR1, name: "Strawberries", price: Money.new(500, :GBP)},
      CF1: %__MODULE__{code: :CF1, name: "Coffee", price: Money.new(1123, :GBP)}
    }
  end
end
