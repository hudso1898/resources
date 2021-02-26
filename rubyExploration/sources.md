# Matt Hudson - Exploration 4 Sources - Industry Preparation (Ruby On Rails)

## 1 - Links to the documentation (Sources I used)

[Rails Official Site](https://rubyonrails.org/) - the official site for Ruby On Rails. It provided an overview of the framework and links to other documentation.

[Ruby Language Guide](https://www.ruby-lang.org/en/documentation/) - official documentation for the Ruby programming language.

[Why's \[poignant\] guide to Ruby](http://poignant.guide/) - a great.. comic book? Documentation? *tutorial* reminiscent of [Learn You a Haskell for Great Good](http://learnyouahaskell.com/). Definitely made this Exploration more fun to do and Ruby more fun to learn.

[Ruby Koans](http://rubykoans.com/) - a popular 'Getting Started' guide for learning the basics of Ruby.

[RoR Official Guide](https://guides.rubyonrails.org/) - official guide Docs for Ruby On Rails. 

[RoR Getting Started](https://guides.rubyonrails.org/getting_started.html) - a getting started guide for Rails. **I adapted this tutorial to help develop for this exploration.**. I went above and beyond that simple tutorial by adding more features such as new input forms, bootstrap styling, and making a journal app rather than an article app.

[How to run rails in the background](https://stackoverflow.com/questions/4334403/how-to-start-rails-server-in-background/19410421) - a similar idea to `pm2`, but works for rails applications (pm2 is used with Node servers)

[Rails in 60 minutes](https://www.youtube.com/watch?v=pPy0GQJLZUM) - a good supplementary Youtube video detailing the fundamentals of Rails.

[Active Record Validation](https://guides.rubyonrails.org/active_record_validations.html) - part of the guide that explained how to write validator functions for a model, including how to use it with a regular expression.

[Layout and Rendering in Rails](https://guides.rubyonrails.org/layouts_and_rendering.html) - another part of the guide that explains Rails' file layout and what the `render` method does.

[link_to method documentation](https://apidock.com/rails/ActionView/Helpers/UrlHelper/link_to) - documentation to the `link_to` helper function, which helped me figure out how to specify the method a link should take (used this for the delete link). Also, I used this to learn how to apply classes to these links using the `class` paramter.

[stylesheet_link_tag documentation](https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/stylesheet_link_tag) - used this to learn how to use the `stylesheet_link_tag` helper method, which allowed me to link to bootstrap's CDN.

[Bootstrap Class List](https://www.w3schools.com/bootstrap/bootstrap_ref_all_classes.asp) - helped me figure out some bootstrap classes I could use in the application.

[Webrick w/ SSL](https://stackoverflow.com/questions/3640993/how-do-you-configure-webrick-to-use-ssl-in-rails) - used this to finally get HTTPS working for Rails.

## 2. Components Explored

For this exploration, I delved into Ruby On Rails, a web application framework for the Ruby language. Rails is self-contained, meaning it implements the entire MVC architecture in a single framework. Overall, I explored the following components:

- What is Ruby on Rails? (framework features and definitions)

- Ruby Language Fundamentals & Test-Driven Development

- Starting and deploying a Rails project through the CLI

- Controllers and Views, including Routing in Rails

- Creating resources and routes using the `resources` helper method

- Creating forms using the `form_for` helper method and embedded ruby (`html.erb` files)

- Data Models and how they link to the database (including what *migration* is)

- Using helper functions to insert links using routing path variables

- Form validation using the model's `validates` function & displaying error feedback

- View Partials (reusable segments of a view)

- Full CRUD operations on the data model using GET, POST, PUT, and DELETE HTTP methods

- Authentication using Rails and confirmation boxes

- Integrating with Bootstrap to produce a well-designed UI interface

- Configuring Rails for HTTPS

## 3. Trouble shooting tidbits (Problems I faced, how I solved them)

On my first try starting the rails server, I was getting errors related to not being able to load some particular files. Through research, I came across [the issue](https://stackoverflow.com/questions/47972479/after-ruby-update-to-2-5-0-require-bundler-setup-raise-exception) - it's just a simple update to `gem` to fix this issue. Additionally, I needed to update my version of `rails` using `sudo apt upgrade rails`.

To have the server up on my instance, I needed to allow port `3000` both on `ufw` and through the Amazon EC2 console. Additionally, I used `nohup` to have the server keep running even after I'm done working through ssh on my instance.

Another problem was that even after doing this, I was still getting a connection refused message. It turns out that `rails`, by default, only listens on the localhost (127.0.0.1). So I had to edit my server command to fix this: `rails server --binding 0.0.0.0`.

I had trouble getting HTTPS to work with Rails - it ultimately boiled down to having to know how Webrick and/or thin ran in Ruby. At first, I consigned to not fixing the issue, but after completing the rest of the project, I was able to figure it out (see my sources below). I also realized I had to go to www.hudso.dev:3000 instead of my actual IP - I was getting a common name error with SSL, and that was why.

One neat part of Rails is that when something goes wrong, the website gives you detailed feedback in the browser. Therefore, finding issues is not as frustrating as
with node servers that just don't return anything - if something goes wrong, Rails will tell you exactly what's wrong. For example, before I made the journal controller,
I got this error which told me exactly what was going on:

![rails-error-info](../screenshots/rails-error-info.png)

While I was starting my forms in the `journal` controller, I was getting 500 errors once I put in ruby into `new.html.erb`. The reason for this seemed to be I was using
the `form_with` helper instead of the `form_for` helper. It also might have been that I was using `form_with` the wrong way, but I ended up using `form_for` and the
500 errors finally went away.

While migrating the databse, I got an error while attempting the migration. It turns out I had accidentally created a model for Journal earlier, so I had to remove that model from the database using `rake db:drop`.

A weird error I got when doing the `journal#index` route was that the entire journal hash was printing at the end of the page. The reason for this was because I was using interpolation `<%= %>` with the `@journals.each` method. Since this is a control structure like an `*ngFor`, removing the equal side prevents any output to the page!

I was getting this error while trying to add validation to the journal form: "Missing template journal/New Entry, application/New Entry with {:locale=>[:en], :formats=>[:html], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :coffee, :jbuilder]}. Searched in: * "/home/mrh4hd/exploration4/app/views" - it turns out I forgot 'single quotes' around `new` in my controller. You have to define a string that defines what to render.

While implementing the update functionality, I was having trouble getting the form to use the PUT method - it was going to POST but giving me a routing error. The solution was to define the `method` paramter to the `form_for` in `_form.html.erb`. This way, I specify POST for `new` and PUT for `edit`. Since HTML forms only do GET/POST, Rails
handles this behind the scenes, by adding a hidden input element called 'method' with value 'put'. Rails then takes this hidden output and lets the server interpret that POST request as a PUT request.
