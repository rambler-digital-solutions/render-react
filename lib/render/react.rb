require 'render/react/version'
require 'mini_racer'
require 'json'
require 'active_support/inflector'

module Render
  module React
    def initialize
      js_path = File.expand_path('../../../js/node_modules', __FILE__)
      @react_render_cxt = MiniRacer::Context.new
      @react_render_cxt.load(js_path + '/react/dist/react.min.js')
      @react_render_cxt.load(js_path + '/react-dom/dist/react-dom-server.min.js')

      components_path = File.expand_path('../../../js/components', __FILE__)
      @react_render_lookup = {}
      Dir.glob(File.join(components_path, '**', '*.js')).each do |filename|
        @react_render_cxt.load(filename)
        @react_render_lookup[File.basename(filename, '.js').camelize.to_sym] = true
      end

      super
    end

    def react(component_class, **props)
      raise "#{component_class} not found in ..." unless @react_render_lookup[component_class.to_sym]
      result = @react_render_cxt.eval "ReactDOMServer.renderToString(React.createElement(#{component_class}, #{JSON.dump(props)}));"
    end
  end
end
