module Render
  module React
    module Compiler
      def cxt
        return @cxt if @cxt
        @cxt = Config.new_context
        %w(
          react/dist/react.min
          react-dom/dist/react-dom-server.min
        ).each do |file|
          @cxt.load(
            File.join(Config.js_path, file + '.js')
          )
        end
        @cxt
      end

      def lookup
        @lookup ||= {}
      end

      def load_components
        Config.paths.each do |path|
          files = Dir.glob(File.join(path, '**', '*.js'))
          files.each do |filename|
            name, code = Transpiler.babelify(filename)
            cxt.eval(code)
            lookup[name.to_sym] = true
          end
        end
      end

      def render(component_class, **props)
        raise "#{component_class} component not found." unless lookup[component_class.to_sym]
        cxt.eval <<-EOS

          var Props = #{JSON.dump(props)};
          var IsomorphicWrapper = React.createClass({
            render: function render() {
              return React.createElement(
                'div',
                {
                  'data-react-component': '#{component_class}',
                  'data-react-isomorphic': true,
                  'data-react-props': JSON.stringify(Props)
                },
                React.createElement(#{component_class}, Props)
              );
            }
          });

          ReactDOMServer.renderToString(
            React.createElement(IsomorphicWrapper, Props)
          );
        EOS
      end

      module_function :load_components, :render, :cxt, :lookup
    end
  end
end
