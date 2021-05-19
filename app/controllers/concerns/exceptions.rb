module Exceptions
  module ApplicationErrors
    class UploadError < StandardError
      attr_reader :message, :path

      def initialize(data)
        @message = data[:message]
        @path = data.key?(:path) ? data[:path] : nil
        super
      end
    end

    class ResourceError < StandardError
      attr_reader :message, :path

      def initialize(data)
        @message = data[:message]
        @path = data.key?(:path) ? data[:path] : nil
        super
      end
    end

    class IsAlreadyLoggedInError < StandardError
      attr_reader :message, :path

      def initialize(data)
        @message = 'You are already logged in'
        @path = data.key?(:path) ? data[:path] : nil
        super
      end
    end
  end
end
