# Todo MVC Glimmer DSL for LibUI Desktop Edition
## [Ruby GUI Desktop Development Hands-On Tutorial](https://docs.google.com/presentation/d/1_9ks9ugAq3PmxJ_RTFvJMJoNnrpm3dO4QiQWJwFi3Is/pub?start=false&loop=false&delayms=60000)

A Ruby desktop application developed with [Glimmer DSL for LibUI](https://github.com/AndyObtiva/glimmer-dsl-libui) as part of the Montreal.rb September 2024 meetup, titled ["Ruby GUI Desktop Development Hands-On Tutorial"](https://docs.google.com/presentation/d/1_9ks9ugAq3PmxJ_RTFvJMJoNnrpm3dO4QiQWJwFi3Is/pub?start=false&loop=false&delayms=60000).

[Presentation Slides](https://bit.ly/3ThsI0H)

## Steps

### Step 1 - Scaffold Application

Scaffold application by running terminal command:

```
glimmer "scaffold[todo_mvc]"
```

Application is scaffolded in `todo_mvc` directory.

Enter application directory by running terminal command:

```
cd todo_mvc
```

Run application by running terminal command:

```
glimmer run
```

or

```
bin/todo_mvc
```

![step 1 app](/screenshots/glimmer-libui-todo-mvc-step1-todo-mvc-application.png)

![step 1 menu](/screenshots/glimmer-libui-todo-mvc-step1-todo-mvc-menu.png)

![step 1 preferences](/screenshots/glimmer-libui-todo-mvc-step1-todo-mvc-preferences.png)

### Step 2 - Add Todos Table with Fake Data

Delete `Greeting` Model by running terminal command:

```
rm app/todo_mvc/model/greeting.rb
```

Create `Todo` Model by running terminal command:

```
touch app/todo_mvc/model/todo.rb
```

Add the following code inside `app/todo_mvc/model/todo.rb`:

```ruby
class TodoMvc
  module Model
    class Todo
      attr_accessor :task
      
      def initialize(task)
        @task = task
      end
    end
  end
end
```

Create `TodoList` Model by running terminal command:

```
touch app/todo_mvc/model/todo_list.rb
```

Add the following code inside `app/todo_mvc/model/todo_list.rb`:

```ruby
require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos
      
      def initialize
        @todos = []
      end
      
      def add_todo(task)
        todos << Todo.new(task)
      end
    end
  end
end
```

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
          
          table {
            text_column('Task')
            
            cell_rows <=> [@todo_list, :todos]
          }
        }
      }
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 2 todo table with fake data](/screenshots/glimmer-libui-todo-mvc-step2-todo-table-with-fake-data.png)

### Step 3 - Add New Todo Entry

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos
      
      def initialize
        @todos = []
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todos << Todo.new(task)
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 3 enter new todo](/screenshots/glimmer-libui-todo-mvc-step3-enter-new-todo.png)

### Step 4 - Add Delete Todo Button

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
          }
        }
      }
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos, :selection_index
      
      def initialize
        @todos = []
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todos << Todo.new(task)
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
      
      def delete_todo
        @todos.delete_at(selection_index)
      end
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 4 delete todo](/screenshots/glimmer-libui-todo-mvc-step4-delete-todo.png)

### Step 5 - Add Completed Table Column

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
          }
        }
      }
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task)
        @task = task
      end
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 5 complete todo](/screenshots/glimmer-libui-todo-mvc-step5-complete-todos.png)

### Step 6 - Add Toggle All Button

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
          }
        }
      }
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo.rb` with the following code:

```ruby
class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task)
        @task = task
      end
      
      def active
        !completed
      end
      
      def mark_completed
        self.completed = true
      end
      
      def mark_active
        self.completed = false
      end
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
require 'todo_mvc/model/todo'

class TodoMvc
  module Model
    class TodoList
      attr_accessor :todos, :selection_index
      
      def initialize
        @todos = []
      end
      
      def add_todo(task = nil)
        task ||= new_todo.task
        todos << Todo.new(task)
        new_todo.task = ''
      end
      
      def new_todo
        @new_todo ||= Todo.new('')
      end
      
      def delete_todo
        @todos.delete_at(selection_index)
      end
      
      def toggle_completion_of_all_todos
        if @todos.any?(&:active)
          @todos.select(&:active).each(&:mark_completed)
        else
          @todos.select(&:completed).each(&:mark_active)
        end
      end
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 6 toggle all todos completed](/screenshots/glimmer-libui-todo-mvc-step6-toggle-all-todos-completed.png)

### Step 7 - Add Items Left Label

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
```

Replace the content of `app/todo_mvc/model/todo.rb` with the following code:

```ruby
class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task, todo_list: nil)
        @task = task
        @todo_list = todo_list
      end
      
      def completed=(value)
        @completed = value
        @todo_list&.recalculate_active_todos
      end
      
      def active
        !completed
      end
      
      def mark_completed
        self.completed = true
      end
      
      def mark_active
        self.completed = false
      end
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
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
```

Run application by running terminal command:

```
glimmer run
```

![step 7 items left](/screenshots/glimmer-libui-todo-mvc-step7-items-left.png)

### Step 8 - Add All/Active/Completed Buttons

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
              
              cell_rows <=> [@todo_list, :displayed_todos]
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
              
              button('All') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :all }]

                on_clicked do
                  @todo_list.filter = :all
                end
              }
              
              button('Active') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :active }]

                on_clicked do
                  @todo_list.filter = :active
                end
              }
              
              button('Completed') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :completed }]

                on_clicked do
                  @todo_list.filter = :completed
                end
              }
            }
          }
        }
      }
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo.rb` with the following code:

```ruby
class TodoMvc
  module Model
    class Todo
      attr_accessor :task, :completed
      
      def initialize(task, todo_list: nil)
        @task = task
        @todo_list = todo_list
      end
      
      def completed=(value)
        @completed = value
        @todo_list&.recalculate_filtered_todos
      end
      
      def active
        !completed
      end
      
      def mark_completed
        self.completed = true
      end
      
      def mark_active
        self.completed = false
      end
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
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
    end
  end
end
```

Run application by running terminal command:

```
glimmer run
```

![step 8 All filter](/screenshots/glimmer-libui-todo-mvc-step8-all-filter.png)

![step 8 Active filter](/screenshots/glimmer-libui-todo-mvc-step8-active-filter.png)

![step 8 Completed filter](/screenshots/glimmer-libui-todo-mvc-step8-completed-filter.png)

### Step 9 - Add Clear Completed Button

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
              
              cell_rows <=> [@todo_list, :displayed_todos]
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
              
              label # filler
              
              button('All') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :all }]

                on_clicked do
                  @todo_list.filter = :all
                end
              }
              
              button('Active') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :active }]

                on_clicked do
                  @todo_list.filter = :active
                end
              }
              
              button('Completed') {
                stretchy false
                
                enabled <= [@todo_list, :filter, on_read: -> (value) { value != :completed }]

                on_clicked do
                  @todo_list.filter = :completed
                end
              }
              
              label # filler
              
              button('Clear Completed') {
                stretchy false
                
                enabled <= [@todo_list, :completed_todos, on_read: :any?]

                on_clicked do
                  @todo_list.clear_completed
                end
              }
            }
          }
        }
      }
    end
  end
end
```

Replace the content of `app/todo_mvc/model/todo_list.rb` with the following code:

```ruby
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
```

Run application by running terminal command:

```
glimmer run
```

![step 9 clear completed button enabled](/screenshots/glimmer-libui-todo-mvc-step9-clear-completed-button-enabled.png)

![step 9 clear completed button clicked](/screenshots/glimmer-libui-todo-mvc-step9-clear-completed-button-clicked.png)

### Step 10 - Refactor To Components

Replace the content of `app/todo_mvc/view/todo_mvc.rb` with the following code:

```ruby
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
```

Create `app/todo_mvc/view/add_todo_form.rb` component by running:

```
glimmer "scaffold:customcontrol[add_todo_form]"
```

Replace the content of `app/todo_mvc/view/add_todo_form.rb` with the following code:

```ruby
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
```

Create `app/todo_mvc/view/toggle_all_bar.rb` component by running:

```
glimmer "scaffold:customcontrol[toggle_all_bar]"
```

Replace the content of `app/todo_mvc/view/toggle_all_bar.rb` with the following code:

```ruby
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
```

Create `app/todo_mvc/view/todo_table.rb` component by running:

```
glimmer "scaffold:customcontrol[todo_table]"
```

Replace the content of `app/todo_mvc/view/todo_table.rb` with the following code:

```ruby
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
```

Create `app/todo_mvc/view/delete_bar.rb` component by running:

```
glimmer "scaffold:customcontrol[delete_bar]"
```

Replace the content of `app/todo_mvc/view/delete_bar.rb` with the following code:

```ruby
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
```

Create `app/todo_mvc/view/filter_bar.rb` component by running:

```
glimmer "scaffold:customcontrol[filter_bar]"
```

Replace the content of `app/todo_mvc/view/filter_bar.rb` with the following code:

```ruby
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
```

Run application by running terminal command:

```
glimmer run
```

![step 9 clear completed button enabled](/screenshots/glimmer-libui-todo-mvc-step9-clear-completed-button-enabled.png)

Contributing to todo_mvc
------------------------------------------

-   Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't
    requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it
    in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If
    you want to have your own version, or is otherwise necessary, that
    is fine, but please isolate to its own commit so I can cherry-pick
    around it.

Copyright
---------

[MIT](LICENSE.txt)

Copyright (c) 2024 Andy Maleh. See
[LICENSE.txt](LICENSE.txt) for further details.
