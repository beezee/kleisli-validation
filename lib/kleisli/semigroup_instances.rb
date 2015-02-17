require "kleisli"

# monkey patch some default semigroup instances

class Array

  def sappend(other)
    concat(other)
  end
end

class Hash

  def sappend(other)
    merge(other) do |k, va, vb|
      va = [va] unless va.kind_of?(Array)
      vb = [vb] unless vb.kind_of?(Array)
      va.concat(vb)
    end
  end
end
