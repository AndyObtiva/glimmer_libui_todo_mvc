require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos
      
      def initialize
        @todos = []
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todos << Todo.new(task)
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
    end
  end
end
