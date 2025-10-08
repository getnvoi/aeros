# desc "Explaining what the task does"
namespace :ui do
  desc "run tailwind"
  task :tailwind_engine_watch do
    require "tailwindcss-rails"

    command = [
      Tailwindcss::Commands.compile_command.first,
      "-i", Ui::Engine.root.join("app/assets/stylesheets/ui/application.tailwind.css").to_s,
      "-o", Ui::Engine.root.join("app/assets/stylesheets/ui/tailwind.css").to_s,
      "-w",
      "--content", [
        Ui::Engine.root.join("app/components/**/*.rb").to_s,
        Ui::Engine.root.join("app/components/**/*.erb").to_s
      ].join(",")
    ]

    p command
    system(*command)
  end
end
