defmodule Blog.Builder do
  alias Blog.{ContentReader, HTMLGenerator}

  def run do
    output_dir = Application.get_env(:blog, :output_dir)

    File.rm_rf!(output_dir)
    File.mkdir_p!(output_dir <> "/static")

    posts = ContentReader.read_all_posts()
    IO.puts("📝 Found #{length(posts)} posts.")

    Enum.each(posts, fn post ->
      html = HTMLGenerator.generate_post_html(post)
      File.write!(Path.join(output_dir, "#{post.slug}.html"), html)
    end)

    index_html = HTMLGenerator.generate_index_html(posts)
    File.write!(Path.join(output_dir, "index.html"), index_html)

    copy_assets(output_dir)

    IO.puts("✅ Build complete in /#{output_dir}")
  end

  defp copy_assets(output_dir) do
    if File.exists?("output.css") do
      File.cp!("output.css", Path.join(output_dir, "static/app.css"))
    end
  end
end
