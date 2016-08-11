require "render/react/version"

module Render
  module React
    def react(component_name, *props)
      "#{component_name}(#{props})"
    end
  end
end
