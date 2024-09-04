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
