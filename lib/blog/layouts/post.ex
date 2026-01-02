defmodule Blog.Layouts.Post do
  alias Blog.Layouts.Root
  use Generator.Layout

  def config(_site) do
    %LayoutConfig{
      parent: Root
    }
  end

  def render(assigns) do
    ~H"""
      <article class="prose-custom prose-lg | max-w-none">
      <h1 class=""><%= @title %></h1>
      <p class="text-base/80">Published on: <%= @data["date"] %></p>

      {include(@inner_content)}
    </article>
    """
  end
end
