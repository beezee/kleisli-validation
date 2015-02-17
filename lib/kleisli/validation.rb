#require "kleisli/validation/version"
require "kleisli"
require "kleisli/semigroup_instances.rb"

module Kleisli
  class Validation < Either
    VERSION = "0.0.1"
    attr_accessor :success, :failure

    def *(other)
      self >-> f {
        other >-> val {
          Success(f.arity > 1 ? f.curry.call(val) : f.call(val))
        }
      }
    end

    class Success < Validation
      alias value success

      def *(other)
        if other.class == Success
          super
        else
          other
        end
      end

      def initialize(success)
        @success = success
      end

      def >(f)
        f.call(@success)
      end

      def fmap(&f)
        Success.new(f.call(@success))
      end

      def to_maybe
        Maybe::Some.new(@success)
      end

      def or(other=nil, &other_blk)
        self
      end

      def to_s
        "Success(#{@success.inspect})"
      end
      alias inspect to_s
    end

    class Failure < Validation
      alias value failure

      def *(other)
        if other.class == Failure
          unless self.failure.class == other.failure.class &&
                  self.failure.respond_to?(:sappend)
            raise ArgumentError,
                    "Failures must contain members of a common Semigroup"
          end
          Failure(self.failure.sappend(other.failure))
        else
          self
        end
      end

      def initialize(failure)
        @failure = failure
      end

      def >(f)
        self
      end

      def fmap(&f)
        self
      end

      def to_maybe
        Maybe::None.new
      end

      def or(other=self, &other_blk)
        if other_blk
          other_blk.call(@failure)
        else
          other
        end
      end

      def to_s
        "Failure(#{@failure.inspect})"
      end
      alias inspect to_s
    end
  end
end

Success = Kleisli::Validation::Success.method(:new)
Failure = Kleisli::Validation::Failure.method(:new)

def Success(v)
  Kleisli::Validation::Success.new(v)
end

def Failure(v)
  Kleisli::Validation::Failure.new(v)
end
