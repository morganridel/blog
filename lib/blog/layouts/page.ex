defmodule Blog.Layouts.Page do
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
      {include(@inner_content)}
    </article>
    """
  end
end
