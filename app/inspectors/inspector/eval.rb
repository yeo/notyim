# frozen_string_literal: true

module Inspector
  class Eval
    SLOW_THRESHOLD = 9000 # in milliseconds
    class << self
      def down(obj)
        obj.status == 'down'
      end

      def up(obj)
        obj.status == 'up'
      end

      def slow(obj, threshold)
        t = obj.total_response_time || 0
        t > threshold
      end

      def eq(obj1, obj2)
        (obj1 == obj2) || (obj1.to_s == obj2.to_s)
      end

      def ne(obj1, obj2)
        !eq(obj1, obj2)
      end

      def gt(obj1, obj2)
        obj1.to_f > obj2.to_f
      end

      def lt(obj1, obj2)
        obj1.to_f < obj2.to_f
      end

      def contain(obj1, obj2)
        obj1.include? obj2
      end

      def in(obj1, obj2)
        contain(obj2, obj1)
      end

      def beat_started
        raise 'not impl'
      end

      def not_beat_started
        raise 'not impl'
      end

      def beat_completed
        raise 'not impl'
      end

      def not_beat_completed
        raise 'not impl'
      end
    end
  end
end
