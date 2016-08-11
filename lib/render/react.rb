require 'render/react/version'
require 'v8'
require 'json'

module Render
  module React
    def initialize
      js_path = File.expand_path('../../../js/node_modules', __FILE__)
      @react_render_cxt = V8::Context.new
      @react_render_cxt.load(js_path + '/react/dist/react.min.js')
      @react_render_cxt.load(js_path + '/react-dom/dist/react-dom-server.min.js')
      super
    end

    def render_react_eval_js(js)
      @react_render_cxt.eval(js)
    end

    def react(_component_class, js_file_path, **props)
      code = <<-EOF
        #{File.read(js_file_path)}

        var element = React.createElement(HelloMessage, #{JSON.dump(props)});
        ReactDOMServer.renderToString(element);
      EOF
      render_react_eval_js(code)
    end
  end
end
