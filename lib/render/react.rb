require 'json'
require 'mini_racer'
require 'active_support/inflector'

require 'render/react/config'
require 'render/react/compiler'
require 'render/react/transpiler'
require 'render/react/version'

module Render
  module React
    def initialize(*args, **kwargs)
      Compiler.load_components
      super
    end

    def render_react(component_class, **props)
      Compiler.render(component_class, **props)
    end
  end
end
