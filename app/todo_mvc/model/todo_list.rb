require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos
      
      def initialize
        @todos = []
      end
      
      def add_todo(task)
        todos << Todo.new(task)
      end
    end
  end
end
