module DBNazi
  module Migration
    def self.included(base)
      base.extend ClassMethods
    end

    def nazi_disabled?
      self.class.nazi_disabled?
    end

    module ClassMethods
      def no_nazi
        @nazi_disabled = true
      end

      def nazi_disabled?
        @nazi_disabled
      end
    end
  end
end
