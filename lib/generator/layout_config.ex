defmodule Generator.LayoutConfig do
  defstruct [:parent]

  @type t :: %__MODULE__{
          parent: module() | nil
        }
end
