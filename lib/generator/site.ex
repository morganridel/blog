defmodule Generator.Site do
  defstruct [
    :title,
    :author,
    :base_url,
    collections: %{},
    pages: [],
    output_dir: "output"
  ]

  @type t :: %__MODULE__{
          title: String.t(),
          author: String.t(),
          base_url: String.t(),
          collections: %{atom() => list(map())},
          pages: list(module()),
          output_dir: String.t()
        }
end
