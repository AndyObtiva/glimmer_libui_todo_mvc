require 'todo_mvc/model/todo_list'

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
            horizontal_box {
              stretchy false
              
              entry {
                text <=> [@todo_list.new_todo, :task]
              }
              button('Add') {
                stretchy false
                
                on_clicked do
                  @todo_list.add_todo
                end
              }
            }
            
            table {
              text_column('Task')
              
              cell_rows <=> [@todo_list, :todos]
            }
          }
        }
      }
    end
  end
end
