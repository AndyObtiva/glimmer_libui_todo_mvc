class TodoMvc
  module View
    class FilterBar
      include Glimmer::LibUI::CustomControl
  
      option :todo_list
  
      body {
        horizontal_box {
          stretchy false
          
          label {
            stretchy false
            
            text <= [todo_list, :active_todos,
                      on_read: -> (todos) { "#{todos.count} item#{'s' if todos.size != 1} left" }
                    ]
          }
          
          label # filler
          
          button('All') {
            stretchy false
            
            enabled <= [todo_list, :filter, on_read: -> (value) { value != :all }]

            on_clicked do
              todo_list.filter = :all
            end
          }
          
          button('Active') {
            stretchy false
            
            enabled <= [todo_list, :filter, on_read: -> (value) { value != :active }]

            on_clicked do
              todo_list.filter = :active
            end
          }
          
          button('Completed') {
            stretchy false
            
            enabled <= [todo_list, :filter, on_read: -> (value) { value != :completed }]

            on_clicked do
              todo_list.filter = :completed
            end
          }
          
          label # filler
          
          button('Clear Completed') {
            stretchy false
            
            enabled <= [todo_list, :completed_todos, on_read: :any?]

            on_clicked do
              todo_list.clear_completed
            end
          }
        }
      }
    end
  end
end
