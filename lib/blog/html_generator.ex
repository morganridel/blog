defmodule Blog.HTMLGenerator do
  require EEx

  # Precompile templates for speed
  EEx.function_from_file(:def, :render_layout, "priv/templates/layout.html.eex", [:assigns])
  EEx.function_from_file(:def, :render_post, "priv/templates/post.html.eex", [:assigns])

  def generate_post_html(post) do
    site_config = Application.get_all_env(:blog)

    inner_content = render_post(post: post)

    render_layout(
      site_title: site_config[:site_title],
      page_title: post.frontmatter.title,
      inner_content: inner_content
    )
  end

  def generate_index_html(posts) do
    site_config = Application.get_all_env(:blog)

    inner_content = """
    <div class="max-w-2xl mx-auto">
      <h2 class="text-3xl font-bold mb-8">Latest Articles</h2>
      <div class="space-y-6">
        #{Enum.map_join(posts, "\n", fn post -> """
      <div class="border-b pb-4">
        <a href="#{post.url}" class="text-2xl text-blue-600 hover:text-blue-800 font-semibold">#{post.frontmatter.title}</a>
        <p class="text-gray-500 text-sm mt-1">#{post.frontmatter.date} • #{site_config[:author]}</p>
      </div>
      """ end)}
      </div>
    </div>
    """

    render_layout(
      site_title: site_config[:site_title],
      page_title: "Home",
      inner_content: inner_content
    )
  end
end
