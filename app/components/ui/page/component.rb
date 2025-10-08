module Ui::Page
  class Component < Ui::ApplicationViewComponent
    option(:title)
    option(:subtitle, optional: true)
    option(:description, optional: true)

    renders_one(:actions_area)
  end
end
