require "kleisli"
require "kleisli/semigroup_instances.rb"

module Kleisli
  class Validation
    VERSION = "0.0.5"

    class Success < Either::Right

      def *(other)
        if other.class == Success
          self >-> f {
            f = f.to_proc
            other >-> val {
              Success(f.arity > 1 ? f.curry.call(val) : f.call(val))
            }
          }
        else
          other
        end
      end

      def fmap(&f)
        Success.new(f.call(@right))
      end

      def to_s
        "Success(#{@right.inspect})"
      end
      alias inspect to_s
    end

    class Failure < Either::Left

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
