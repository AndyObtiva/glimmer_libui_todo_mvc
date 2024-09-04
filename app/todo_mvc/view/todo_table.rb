class TodoMvc
  module View
    class TodoTable
      include Glimmer::LibUI::CustomControl
  
      option :todo_list

      body {
        table {
          checkbox_column('Completed') {
            editable true
          }
          text_column('Task')
          
          cell_rows <=> [todo_list, :displayed_todos]
          selection <=> [todo_list, :selection_index]
        }
      }
    end
  end
end
