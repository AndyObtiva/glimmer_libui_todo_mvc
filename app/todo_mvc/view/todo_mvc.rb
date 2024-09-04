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
            
            horizontal_box {
              stretchy false
              
              button('Toggle All') {
                stretchy false
                
                on_clicked do
                  @todo_list.toggle_completion_of_all_todos
                end
              }
            }
            
            table {
              checkbox_column('Completed') {
                editable true
              }
              text_column('Task')
              
              cell_rows <=> [@todo_list, :todos]
              selection <=> [@todo_list, :selection_index]
            }
            
            horizontal_box {
              stretchy false
              
              button('Delete') {
                stretchy false
                
                enabled <= [@todo_list, :selection_index, on_read: -> (value) { !!value }]
                
                on_clicked do
                  @todo_list.delete_todo
                end
              }
            }
            
            horizontal_box {
              stretchy false
              
              label {
                stretchy false
                
                text <= [@todo_list, :active_todos,
                          on_read: -> (todos) { "#{todos.count} item#{'s' if todos.size != 1} left" }
                        ]
              }
            }
          }
        }
      }
    end
  end
end
