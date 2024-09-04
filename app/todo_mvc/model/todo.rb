class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task)
        @task = task
      end
    end
  end
end
