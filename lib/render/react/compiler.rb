module Render
  module React
    module Compiler
      def lookup
        @lookup ||= {}
      end

      def create_context
        @cxt = Config.new_context
        @durability = Config::CONTEXT_DURABILITY

        js_lib_files = Dir.glob(
          File.join(
            Config.gem_js_path,
            'compiler',
            '**',
            '*.js'
          )
        )

        js_lib_files.each { |file| @cxt.load(file) }
      end

      def load_components
        Config.paths.each do |path|
          files = Dir.glob(File.join(path, '**', '*.js'))
          files.each do |filename|
            name, code = Transpiler.babelify(filename)
            @cxt.eval(code)
            lookup[name.to_sym] = true
          end
        end
      end

      def bootstrap
        if @durability
          if @durability <= 1
            @cxt.dispose
            @cxt = nil
            create_context
            load_components
          else
            @durability -= 1
          end
        else
          create_context
          load_components
        end
      end

      def render(component_class, **props)
        unless lookup[component_class.to_sym]
          raise "#{component_class} component not found."
        end
        @cxt.eval <<-EOS
          var component = React.createElement(#{component_class}, #{JSON.dump(props)});
          ReactDOMServer.renderToString(component);
        EOS
      end

      def evaljs(code)
        @cxt.eval(code)
      end

      module_function :bootstrap, :create_context, :render, :lookup, :evaljs, :load_components
    end
  end
end
