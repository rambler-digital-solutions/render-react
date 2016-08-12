module Render
  module React
    module Transpiler
      def cxt
        return @cxt if @cxt
        @cxt = Config.new_context
        @cxt.load(Config.js_path + '/babel-standalone/babel.min.js')
        @cxt.load(Config.js_path + '/react/dist/react.js')
        @cxt
      end

      def babelify(filepath)
        code = File.read(filepath)
        component_name = code.match(/export default (\w+?);/)[1]

        code.gsub!(/export[^;]+;/, '')
        code.gsub!(/import[^;]+;/, '')
        code.gsub!(/require[^;]+;/, '')

        transormation  =<<-EOF
          var input = #{JSON.dump(code)};
          Babel.transform(input, {"presets": ['stage-0', 'es2015', 'react'], "plugins": ["transform-class-properties"]}).code;
        EOF

        result = cxt.eval transormation
        result = "var Component = React.Component;" + result

        [component_name, result]
      end

      module_function :babelify, :cxt
    end
  end
end
