defmodule Bankoo.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bankoo.Catalog.ProductCategories

  schema "categories" do
    field :title, :string

    many_to_many :product, ProductCategories, join_through: "product_categories"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
