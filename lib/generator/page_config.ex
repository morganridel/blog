defmodule Generator.PageConfig do
  @enforce_keys [:title]
  defstruct [:permalink, :layout, :title]

  @type t :: %__MODULE__{
          permalink: String.t() | nil,
          layout: module() | nil,
          title: String.t()
        }
end
