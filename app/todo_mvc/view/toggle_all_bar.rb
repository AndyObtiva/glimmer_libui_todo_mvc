class TodoMvc
  module View
    class ToggleAllBar
      include Glimmer::LibUI::CustomControl
  
      option :todo_list
      
      body {
        horizontal_box {
          button('Toggle All') {
            stretchy false
            
            on_clicked do
              todo_list.toggle_completion_of_all_todos
            end
          }
        }
      }
    end
  end
end
