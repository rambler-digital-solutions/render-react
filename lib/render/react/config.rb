module Render
  module React
    module Config
      def path(*paths)
        @paths ||= []
        @paths += paths
      end

      def paths
        @paths
      end

      def new_context
        MiniRacer::Context.new
      end

      def js_path
        @js_path ||= File.expand_path('../../../../js/node_modules', __FILE__)
      end

      module_function :path, :paths, :new_context, :js_path
    end
  end
end
