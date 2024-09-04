require 'todo_mvc/model/todo_list'

require 'todo_mvc/view/add_todo_form'
require 'todo_mvc/view/toggle_all_bar'
require 'todo_mvc/view/todo_table'
require 'todo_mvc/view/delete_bar'
require 'todo_mvc/view/filter_bar'

class TodoMvc
  module View
    class TodoMvc
      include Glimmer::LibUI::Application
    
      before_body do
        @todo_list = Model::TodoList.new
        ['Home Improvement', 'Shopping', 'Cleaning'].each do |task|
          @todo_list.add_todo(task)
        end
      end
  
      body {
        window {
          title 'Todo MVC'
          content_size 480, 480
          margined true

          vertical_box {
            add_todo_form(todo_list: @todo_list) {
              stretchy false
            }
            
            toggle_all_bar(todo_list: @todo_list) {
              stretchy false
            }
            
            todo_table(todo_list: @todo_list)
            
            delete_bar(todo_list: @todo_list) {
              stretchy false
            }
            
            filter_bar(todo_list: @todo_list) {
              stretchy false
            }
          }
        }
      }
    end
  end
end
