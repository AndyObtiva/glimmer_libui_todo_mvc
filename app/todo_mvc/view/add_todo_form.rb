class TodoMvc
  module View
    class AddTodoForm
      include Glimmer::LibUI::CustomControl
  
      option :todo_list
  
      body {
        horizontal_box {
          entry {
            text <=> [todo_list.new_todo, :task]
          }
          button('Add') {
            stretchy false
            
            on_clicked do
              todo_list.add_todo
            end
          }
        }
      }
    end
  end
end
