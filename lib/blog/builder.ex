# defmodule Blog.Builder do
#   alias Blog.{ContentReader, HTMLGenerator}

#   defp posts_dir(), do: Application.get_env(:blog, :posts_dir)

#   def run do
#     output_dir = Application.get_env(:blog, :output_dir)

#     File.rm_rf!(output_dir)
#     File.mkdir_p!(output_dir <> "/static")

#     contents = ContentReader.read_all_posts()
#     IO.puts("📝 Found #{length(contents)} contents.")
#     IO.inspect(contents)

#     Enum.each(contents, fn content ->
#       process_content(content)
#     end)

#     index_html =
#       HTMLGenerator.generate_index_html(
#         contents
#         |> Enum.filter(&match_posts?/1)
#         |> Enum.map(fn {:post, post} -> post end)
#         |> Enum.sort_by(& &1.frontmatter.date, {:desc, Date})
#       )

#     File.write!(Path.join(output_dir, "index.html"), index_html)

#     copy_assets(output_dir)

#     IO.puts("✅ Build complete in /#{output_dir}")
#   end

#   defp match_posts?({:post, _}), do: true
#   defp match_posts?(_), do: false

#   defp process_content({:post, post}) do
#     output_dir = Application.get_env(:blog, :output_dir)
#     html = HTMLGenerator.generate_post_html(post)
#     file_path = Path.join([output_dir, post.path, "#{post.slug}.html"])

#     with :ok <- File.mkdir_p(Path.dirname(file_path)) do
#       File.write!(file_path, html)
#     end
#   end

#   defp process_content({:default, path}) do
#     output_dir = Application.get_env(:blog, :output_dir)
#     source_path = Path.join([posts_dir(), path])
#     file_path = Path.join([output_dir, path])

#     IO.puts("Processing content...")
#     IO.inspect(path)
#     IO.inspect(file_path)
#     # Just copy the file
#     with :ok <- File.mkdir_p(Path.dirname(file_path)) do
#       File.cp!(source_path, file_path)
#     end
#   end

#   defp copy_assets(output_dir) do
#     if File.exists?("output.css") do
#       File.cp!("output.css", Path.join(output_dir, "static/app.css"))
#     end
#   end
# end
