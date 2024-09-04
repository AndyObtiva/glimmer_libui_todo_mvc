class TodoMvc
  module View
    class DeleteBar
      include Glimmer::LibUI::CustomControl
  
      option :todo_list
  
      body {
        horizontal_box {
          button('Delete') {
            stretchy false
            
            enabled <= [todo_list, :selection_index, on_read: -> (value) { !!value }]
            
            on_clicked do
              todo_list.delete_todo
            end
          }
        }
      }
    end
  end
end
