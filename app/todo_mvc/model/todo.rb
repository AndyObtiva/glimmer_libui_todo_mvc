class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task)
        @task = task
      end
      
      def active
        !completed
      end
      
      def mark_completed
        self.completed = true
      end
      
      def mark_active
        self.completed = false
      end
    end
  end
end
