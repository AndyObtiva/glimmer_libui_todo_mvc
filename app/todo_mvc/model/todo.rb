class TodoMvc
  module Model
    class Todo
      attr_accessor :task
      
      def initialize(task)
        @task = task
      end
    end
  end
end
