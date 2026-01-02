defmodule Generator.Page do
  alias Generator.Site
  alias Generator.PageConfig

  @callback config(site :: Site.t()) :: PageConfig.t()
  @callback data(site :: map()) :: map()
  @callback render(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour Generator.Page
      # Gives you ~H and attr/slot support
      import Phoenix.Component
      alias Generator.PageConfig

      # Default empty data
      def data(_site), do: %{}
      defoverridable data: 1
    end
  end
end
