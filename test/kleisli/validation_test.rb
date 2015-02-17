require 'test_helper'

class ValidationTest < Minitest::Test
  def test_lift_right
    assert_equal 3, Success(3).value
  end

  def test_lift_left
    assert_equal "error", Failure("error").value
  end

  def test_bind_right
    v = Success(1) >-> x {
      if x == 1
        Success(x + 90)
      else
        Failure("FAIL")
      end
    }
    assert_equal Success(91), v
  end

  def test_bind_left
    v = Failure("error") >-> x {
      Success(x * 20)
    }
    assert_equal Failure("error"), v
  end

  def test_fmap_right
    assert_equal Success(2), Success(1).fmap { |x| x * 2 }
  end

  def test_fmap_left
    assert_equal Failure("error"), Failure("error").fmap { |x| x * 2 }
  end

  def test_to_maybe_right
    assert_equal Some(2), Success(1).fmap { |x| x * 2 }.to_maybe
  end

  def test_to_maybe_left
    assert_equal None(), Failure("error").fmap { |x| x * 2 }.to_maybe
  end

  def test_pointfree
    assert_equal Success(10), Success(5) >> F . fn(&Success) . *(2)
  end

  def test_applicative_functor_right_arity_1
    assert_equal Success(20), Success(-> x { x * 2 }) * Success(10)
  end

  def test_applicative_functor_right_arity_2
    assert_equal Success(20), Success(-> x, y { x * y }) * Success(10) * Success(2)
  end

  def test_applicative_functor_left
    assert_equal Failure("error"), Success(-> x, y { x * y }) * Failure("error") * Success(2)
  end

  def test_accumulates_failures
    assert_raises(ArgumentError) { Some(-> x, y { x+y }) * Failure(1) * Failure([2]) }

    assert_equal Failure(["error", "another error"]),
      (Success(-> x, y, z { x * y * z }) * Failure(["error"]) *
                              Success(2) * Failure(["another error"]))

    assert_equal Failure(a: 1, b: [2, 3]),
      (Success(-> x, y, z { x * y * z }) * Failure(a: 1, b: 2) *
                              Success(2) * Failure(b: 3))
  end
end
