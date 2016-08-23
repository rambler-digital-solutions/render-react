module Render
  module React
    module Transpiler
      def cxt
        return @cxt if @cxt
        @cxt = Config.new_context

        js_lib_files = Dir.glob(
          File.join(
            Config.gem_js_path,
            'transpiler',
            '**',
            '*.js'
          )
        )
        js_lib_files.each { |file| @cxt.load(file) }

        @cxt
      end

      def babelify(filepath)
        code = File.read(filepath)
        component_name_match = code.match(/export default (\w+?);/)
        raise "can't find component name in #{filepath}" unless component_name_match
        component_name = component_name_match[1]

        code.gsub!(/export[^;]+;/, '')
        code.gsub!(/import[^;]+;/, '')
        code.gsub!(/require[^;]+;/, '')

        transormation = <<-EOF
          var input = #{JSON.dump(code)};
          Babel.transform(input, {
            "presets": ['stage-0', 'es2015', 'react'],
            "plugins": ["transform-class-properties"]
          }).code;
        EOF
        result = cxt.eval transormation
        result = 'var Component = React.Component;' + result

        [component_name, result]
      end

      module_function :babelify, :cxt
    end
  end
end
