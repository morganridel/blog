## Templating Engine

I am currently using HEEx as my template engine but I'm not completely satisfied in how it integrates with my code. It is designed to work mostly with Phoenix and I can't easily use it outside, except if all my templates are defined in ~H Sigils. But I want my users to be able to provide simple `.html.heex` files.

the `embed_templates` macro is used for compile time compiling of templates but only works with folder relative to the folded where it is used, which means it is not practical to setup on behalf on the final user.

When the user defines `~H` it works ok, but if I want to compile directly from files I can use the EEx while passing the Phoenix engine, but I can't really be sure that I'm missing on some features?

```
EEx.function_from_file(
    :def, :sample, "sample.html.heex", [:assigns], engine: Phoenix.LiveView.HTMLEngine)
````
Apparently for use with some live component, it needs more parameters
```
EEx.function_from_file(
    :def,
    :sample,
    source,
    [:assigns],
    engine: Phoenix.LiveView.HTMLEngine,
    caller: __ENV__,
    source: source
  )
```

Alternative would be to also allow different template engine: Slime, **Temple**...
Temple in particular looks interesting, especially if it can benefits from type system in the future, since the DSL is elixir.
My problem with alternative templating system is that even if they looks good, it wouldn't be coherent if I need to write some custom elements (web component) for example, as the inner HTML would be defined in javascript.

NOTE: EEx.function_from_file is a compile time macro, so maybe use https://hexdocs.pm/eex/EEx.html#compile_file/2 instead and store the function at runtime.

## Runtime vs Compile time

In other static site generators, you usally are able to compile the templates by using the paths of the files, and then just using Typsecript/Python.. to just read the files as everything is runtime.
In Elixir when I run my generator, everything is Module names, and I can't necesarily retrieve a module name from a path. So if the user want to tell me "parse all the pages in `content/pages`. I can't really do it unless I compile these files at runtime. But that could be compiling files that were already compiled before.

If I do want to do it at compile time, this would imply more complex code (macro..) and I need the user to fill a config file with the paths in advance which reduce my "explicit" DX of doing `Generator.addPages("content/pages")`.

I'm not experienced enough in Elixir to see the elegant solution here, so I mostly do everything dynamically at runtime, but I find it a bit frustrating.

Would I even gain speed if I compiled everything first? As the "runtime" is not long lasting, it doesn't really matter if time spent for compiling the template is done at runtime or compile time. I will do both everytime anyway.