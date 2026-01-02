defmodule Mix.Tasks.Build do
  alias Blog.Layouts.Post
  use Mix.Task
  require Logger

  def run(_) do
    Generator.init()
    |> Generator.add_pages("content/pages")
    |> Generator.add_collection("content/posts", %{layout: Post})
    |> Generator.build()
  end

  # defp build_site do
  #   Logger.info("📄 Generating HTML with Elixir...")

  #   {:ok, _} = Application.ensure_all_started(:blog)

  #   Blog.Builder.run()
  # end
end
