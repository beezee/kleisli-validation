#require "kleisli/validation/version"
require "kleisli"
require "kleisli/semigroup_instances.rb"

module Kleisli
  class Validation < Either
    VERSION = "0.0.2"

    def *(other)
      self >-> f {
        other >-> val {
          Success(f.arity > 1 ? f.curry.call(val) : f.call(val))
        }
      }
    end

    class Success < Validation
      alias value right

      def *(other)
        if other.class == Success
          super
        else
          other
        end
      end

      def initialize(right)
        @right = right
      end

      def >(f)
        f.call(@right)
      end

      def fmap(&f)
        Success.new(f.call(@right))
      end

      def to_maybe
        Maybe::Some.new(@right)
      end

      def or(other=nil, &other_blk)
        self
      end

      def to_s
        "Success(#{@right.inspect})"
      end
      alias inspect to_s
    end

    class Failure < Validation
      alias value left

      def *(other)
        if other.class == Failure
          unless self.left.class == other.left.class &&
                  self.left.respond_to?(:sappend)
            raise ArgumentError,
                    "Failures must contain members of a common Semigroup"
          end
          Failure(self.left.sappend(other.left))
        else
          self
        end
      end

      def initialize(left)
        @left = left
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
          other_blk.call(@left)
        else
          other
        end
      end

      def to_s
        "Failure(#{@left.inspect})"
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
