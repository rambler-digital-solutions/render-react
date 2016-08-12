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
          ReactDOMServer.renderToString(
            React.createElement(#{component_class}, #{JSON.dump(props)})
          );
        EOS
      end

      module_function :load_components, :render, :cxt, :lookup
    end
  end
end
