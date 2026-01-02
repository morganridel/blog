defmodule Generator.Layout do
  alias Generator.Site
  alias Generator.LayoutConfig

  @callback config(site :: Site.t()) :: LayoutConfig.t()
  @callback render(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Generator.Layout
      # Gives you ~H and attr/slot support
      import Phoenix.Component
      import Phoenix.HTML
      import Generator.Layout
      alias Generator.LayoutConfig
    end
  end

  # HEEx will have no problem including other HEEx rendered content, but will escape everything if it's raw html
  # So we insert a different data depending on the child content format
  def include(child_content) do
    case child_content do
      %Phoenix.LiveView.Rendered{} -> child_content
      _ -> Phoenix.HTML.raw(child_content)
    end
  end
end
