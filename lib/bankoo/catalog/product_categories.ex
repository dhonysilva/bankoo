defmodule Bankoo.Catalog.ProductCategories do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bankoo.Catalog.Product
  alias Bankoo.Catalog.Category

  schema "product_categories" do
    belongs_to :product, Product
    belongs_to :category, Category
  end

  def changeset(product_category, attrs) do
    product_category
    |> cast(attrs, [:product_id, :category_id])
    |> unique_constraint([:product, :category],
      name: "product_categories_product_id_category_id_index"
    )
  end
end
