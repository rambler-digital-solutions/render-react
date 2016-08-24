require 'json'
require 'v8'
require 'active_support/inflector'

require 'render/react/config'
require 'render/react/compiler'
require 'render/react/transpiler'
require 'render/react/version'

module Render
  module React
    def render_react(component_class, **props)
      Compiler.bootstrap
      "<span data-react-isomorphic='true' " \
        "data-react-component='#{component_class}' " \
        "data-react-props='#{JSON.dump(props)}'>" \
        "#{Compiler.render(component_class, **props)}" \
        '</span>'
    end
  end
end
