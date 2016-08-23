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

      def gem_js_path
        @gem_js_path ||= File.expand_path('../../../../js/dist', __FILE__)
      end

      module_function :path, :paths, :new_context, :gem_js_path
    end
  end
end
