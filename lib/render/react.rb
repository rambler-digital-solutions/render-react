require 'render/react/version'
require 'mini_racer'
require 'json'
require 'active_support/inflector'

module Render
  module React
    module ClassMethods
      def render_react_from(*paths)
        @render_react_paths ||= []
        @render_react_paths += paths
      end

      attr_reader :render_react_paths
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize
      js_path = File.expand_path('../../../js/node_modules', __FILE__)
      @react_render_cxt = MiniRacer::Context.new
      @react_render_cxt.load(js_path + '/react/dist/react.min.js')
      @react_render_cxt.load(js_path + '/react-dom/dist/react-dom-server.min.js')
      @react_render_cxt.load(js_path + '/babel-standalone/babel.min.js')

      @react_render_lookup = {}
      self.class.render_react_paths.each do |path|
        files = Dir.glob(File.join(path, '**', '*.js'))
        p files
        files.each do |filename|
          @react_render_cxt.load(filename)
          @react_render_lookup[File.basename(filename, '.js').camelize.to_sym] = true
        end
      end

      super
    end

    def render_react(component_class, **props)
      raise "#{component_class} component not found." unless @react_render_lookup[component_class.to_sym]
      result = @react_render_cxt.eval "ReactDOMServer.renderToString(React.createElement(#{component_class}, #{JSON.dump(props)}));"
    end

    def render_babel()
      string = "var HelloMessage = React.createClass({render: function() { return <div>Hello {this.props.name}</div>;}});"

      code  =<<-EOF
        var input = '#{string}';
        Babel.transform(input, { presets: ['es2015', 'react'] }).code;
      EOF
      puts code
      @react_render_cxt.eval code
    end
  end
end
