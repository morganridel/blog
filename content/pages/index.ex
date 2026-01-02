defmodule Pages.Index do
  alias Generator.Site
  use Generator.Page

  def config(_site) do
    %PageConfig{
      permalink: "/",
      title: "Home",
      layout: Blog.Layouts.Root
    }
  end

  def data(%Site{} = site) do
    %{posts: site.collections.posts.items |> Enum.sort_by(&Generator.Utils.parse_date!(&1.data["date"]), {:desc, Date})}
  end

  def render(assigns) do
  ~H"""
  <section>
    <div class="stack-md">
      <%= for post <- @posts do %>
        <div class="border-accent border-l-md pl-sm">
          <a href={post.permalink} class="text-2xl font-semibold | hover:text-accent transition-colors">
            <%= post.data["title"] %>
          </a>
          <p class="text-base/80 text-sm"><%= post.data["date"] %></p>
        </div>
      <% end %>
    </div>
  </section>
  """
end
end
