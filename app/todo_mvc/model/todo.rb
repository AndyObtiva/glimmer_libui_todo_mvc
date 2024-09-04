class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task, todo_list: nil)
        @task = task
        @todo_list = todo_list
      end
      
      def completed=(value)
        @completed = value
        @todo_list&.recalculate_active_todos
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
