defmodule Mix.Tasks.Scripts.New do
  use Mix.Task
  import Mix.Generator

  @moduledoc """
  Creates a new executable Elixir script based on the template in `templates/script.exs.eex`.

  ## Options

  | Flag                        |                                                                              | default        |
  | --------------------------- | ---------------------------------------------------------------------------- | -------------- |
  | --deps-only, --no-deps-only | includes a block that terminates the script after running `Mix.install(...)` | --no-deps-only |
  | --tests, --no-tests         | includes a block that runs inline `ExUnit` tests when `MIX_ENV = test`       | --no-tests     |

  """
  @shortdoc "create a new executable script based on the template"

  @args [deps_only: :boolean, tests: :boolean]
  def run(args) do
    scripts_dir = "./bin"
    {opts, [name]} = OptionParser.parse!(args, strict: @args)
    opts = Keyword.merge([deps_only: false, tests: false], opts)

    mod = Macro.camelize(name)
    script = Macro.underscore(name)
    script_path = Path.join(scripts_dir, script)

    assigns = Keyword.merge([mod: mod, script: script], opts)

    template =
      EEx.eval_file("templates/script.exs.eex", assigns: assigns)
      |> Code.format_string!()

    create_file(script_path, template)
    File.chmod!(script_path, 0o755)
  end
end
