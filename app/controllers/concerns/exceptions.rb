module Exceptions
  module ApplicationErrors
    class UploadError < StandardError
      attr_reader :message

      def initialize(data)
        @message = data[:message]
        super
      end
    end
  end
end
