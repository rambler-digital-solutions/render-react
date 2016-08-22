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
      <<-EOS
        <span data-react-isomorphic='true' data-react-component='#{component_class}' data-react-props='#{JSON.dump(props)}'>#{Compiler.render(component_class, **props)}</span>
      EOS
    end
  end
end
