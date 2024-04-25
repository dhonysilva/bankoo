defmodule Bankoo.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bankoo.Catalog.ProductCategories

  schema "products" do
    field :description, :string
    field :title, :string
    field :price, :decimal
    field :views, :integer

    has_many :product_categories, ProductCategories, on_replace: :delete

    has_many :categories, through: [:product_categories, :category]

    # many_to_many :categories, Bankoo.Catalog.Category, join_through: "product_categories", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price, :views])
    |> validate_required([:title, :description, :price, :views])
    |> cast_assoc(:product_categories,
      with: &ProductCategories.changeset/2,
      sort_param: :categories_order,
      drop_param: :categories_delete
    )
  end
end
