module Render
  module React
    module Compiler
      def lookup
        @lookup ||= {}
      end

      def cxt
        return @cxt if @cxt
        @cxt = Config.new_context

        js_lib_files = Dir.glob(
          File.join(
            Config.gem_js_path,
            'compiler',
            '**',
            '*.js'
          )
        )
        js_lib_files.each { |file| @cxt.load(file) }

        @cxt
      end

      def load_components
        return if @components_loaded
        Config.paths.each do |path|
          files = Dir.glob(File.join(path, '**', '*.js'))
          files.each do |filename|
            name, code = Transpiler.babelify(filename)
            cxt.eval(code)
            lookup[name.to_sym] = true
          end
        end
        @components_loaded = true
      end

      def render(component_class, **props)
        unless lookup[component_class.to_sym]
          raise "#{component_class} component not found."
        end
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
