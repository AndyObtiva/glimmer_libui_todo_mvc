require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos, :active_todos, :completed_todos, :displayed_todos, :selection_index, :filter
      
      def initialize
        @todos = []
        @active_todos = []
        @completed_todos = []
        @displayed_todos = @todos
        @filter = :all
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todo = Todo.new(task, todo_list: self)
        todos << todo
        recalculate_filtered_todos
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
      
      def delete_todo
        @todos.delete_at(selection_index)
        recalculate_filtered_todos
      end
      
      def toggle_completion_of_all_todos
        if @todos.any?(&:active)
          @todos.select(&:active).each(&:mark_completed)
        else
          @todos.select(&:completed).each(&:mark_active)
        end
      end
      
      def recalculate_filtered_todos
        self.completed_todos = @todos.select(&:completed)
        self.active_todos = @todos.select(&:active)
        recalculate_displayed_todos
      end
      
      def filter=(filter_value)
        @filter = filter_value
        recalculate_displayed_todos
      end
      
      def recalculate_displayed_todos
        case filter
        when :all
          self.displayed_todos = todos
        when :active
          self.displayed_todos = active_todos
        when :completed
          self.displayed_todos = completed_todos
        end
      end
      
      def clear_completed
        @completed_todos.each { |todo| @todos.delete(todo) }
        recalculate_filtered_todos
      end
    end
  end
end
