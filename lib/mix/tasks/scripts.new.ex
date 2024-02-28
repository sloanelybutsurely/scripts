defmodule Mix.Tasks.Scripts.New do
  use Mix.Task
  import Mix.Generator

  @args []
  def run(args) do
    scripts_dir = "./bin"
    {_, [name]} = OptionParser.parse!(args, strict: @args)

    mod = Macro.camelize(name)
    script = Macro.underscore(name)
    script_path = Path.join(scripts_dir, script)

    assigns = [mod: mod, script: script]

    copy_template("templates/script.exs.eex", script_path, assigns)
    File.chmod!(script_path, 0o755)
  end
end
