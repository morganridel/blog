defmodule Generator.ContentReader do
  def read_all_files(path, collection_config) do
    Path.wildcard(path <> "/**")
    |> Enum.filter(&File.regular?/1)
    |> Enum.map(&parse_content(&1, collection_config))
    |> Enum.reject(&(&1 == :ignore))
  end

  def parse_content(path, collection_config) do
    ext = Path.extname(path)

    cond do
      ext in [".md", ".mdx"] ->
        read_markdown(path, collection_config)

      ext in [".html", ".jpg", ".png", ".jpeg", ".mp4"] ->
        raise "Doesn't handle image and static file in collection yet"

      true ->
        :ignore
    end
  end

  def read_markdown(file_path, collection_config) do
    raw_content = File.read!(file_path)

    doc =
      MDEx.parse_document!(raw_content,
        extension: [shortcodes: true, front_matter_delimiter: "---"]
      )

    frontmatter = parse_frontmatter(doc)

    filename = Path.basename(file_path, Path.extname(file_path))

    # Handle nested index.mdx for legacy purpose for now
    # Need to properly handle root markdown vs folder in the future, along with local images to the collection
    slug =
      case filename do
        "index" -> Path.basename(Path.dirname(file_path))
        _ -> filename
      end

    # handling my legacy posts
    # Ugly strip of the date for now because I only use posts, later it should be a "pre-processor" or something
    slug =
      String.replace(
        slug,
        ~r/^\d{4}-\d{2}-\d{2}-/,
        ""
      )

    permalink =
      String.replace(frontmatter["permalink"] || collection_config[:permalink], ":name", slug)

    layout =
      case frontmatter["layout"] do
        nil -> collection_config.layout
        layout -> String.to_existing_atom("Elixir." <> layout)
      end

    %Generator.CollectionItem{
      id: slug,
      slug: slug,
      title: frontmatter["title"],
      layout: layout,
      permalink: permalink,
      data: frontmatter,
      body: doc |> MDEx.to_html!(),
      path: file_path
    }
  end

  defp parse_frontmatter(%MDEx.Document{} = doc) do
    %MDEx.FrontMatter{literal: text} = doc[MDEx.FrontMatter] |> List.first()

    split_pattern = ~r/[\s\r\n]---[\s\r\n]/s

    # Copied from front_matter to avoid importing a lib just for that
    # https://github.com/boostingtech/front_matter/blob/main/lib/front_matter.ex
    extracted_yaml =
      text
      |> (&String.trim_leading(&1)).()
      |> (&("\n" <> &1)).()
      |> (&Regex.split(split_pattern, &1, parts: 3)).()

    {:ok, frontmatter} = YamlElixir.read_from_string(extracted_yaml)

    frontmatter
  end
end
