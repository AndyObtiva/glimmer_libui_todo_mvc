require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos, :selection_index
      
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
      
      def delete_todo
        @todos.delete_at(selection_index)
      end
      
      def toggle_completion_of_all_todos
        if @todos.any?(&:active)
          @todos.select(&:active).each(&:mark_completed)
        else
          @todos.select(&:completed).each(&:mark_active)
        end
      end
    end
  end
end
