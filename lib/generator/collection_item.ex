# Should this just become a page struct?
defmodule Generator.CollectionItem do
  defstruct [:id, :slug, :title, :layout, :permalink, :data, :body, :path]
end
