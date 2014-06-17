require 'sprockets/compressing'

Sprockets::Compressing.module_eval do
    def html_compressor
      @html_compressor if defined? @html_compressor
    end

    def html_compressor=(compressor)
      unregister_bundle_processor 'text/html', html_compressor if html_compressor
      @html_compressor = nil
      return unless compressor

      if compressor.is_a?(Symbol)
        compressor = compressors['text/html'][compressor] || raise(Error, "unknown compressor: #{compressor}")
      end

      if compressor.respond_to?(:compress)
        klass = Class.new(Processor) do
          @name = 'html_compressor'
          @processor = proc { |context, data| compressor.compress(data) }
        end
        @html_compressor = :html_compressor
      else
        @html_compressor = klass = compressor
      end

      register_bundle_processor 'text/html', klass
    end
end
