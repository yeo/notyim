module Inspector
  class Eval
    SLOW_THRESHOLD = 9000 # in milliseconds
    class << self
      def down(a)
        a.status == 'down'
      end

      def up(a)
        a.status == 'up'
      end

      def slow(a, threshold)
        a.total_response_time > threshold
      end

      def eq(a, b)
        a == b
      end

      def ne(a, b)
        !eq(a, b)
      end

      def gt(a, b)
        a.to_f > b.to_f
      end

      def lt(a, b)
        a.to_f < b.to_f
      end

      def contain(a, b)
        a.include? b
      end

      def in(a, b)
        contain(b, a)
      end

      def beat_started
        raise "not impl"
      end

      def not_beat_started
        raise "not impl"
      end

      def beat_completed
        raise "not impl"
      end

      def not_beat_completed
        raise "not impl"
      end

    end
  end
end
