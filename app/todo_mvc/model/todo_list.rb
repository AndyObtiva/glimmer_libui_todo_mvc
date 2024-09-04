require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos, :active_todos, :selection_index
      
      def initialize
        @todos = []
        @active_todos = []
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todo = Todo.new(task, todo_list: self)
        todos << todo
        recalculate_active_todos
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
      
      def delete_todo
        @todos.delete_at(selection_index)
        recalculate_active_todos
      end
      
      def toggle_completion_of_all_todos
        if @todos.any?(&:active)
          @todos.select(&:active).each(&:mark_completed)
        else
          @todos.select(&:completed).each(&:mark_active)
        end
      end
      
      def recalculate_active_todos
        self.active_todos = @todos.select(&:active)
      end
    end
  end
end
