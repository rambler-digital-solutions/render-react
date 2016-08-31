### Work in progress, please beware.

## Overview
This gem renders [React](https://facebook.github.io/react/) components into your views!

It's plain Ruby so you can use it with almost every Ruby framework out there.

## Design
It uses [V8 engine](https://developers.google.com/v8/) as dynamic library for JavaScript execution. On application load React components are discovered, compiled from ES6 to ES5 and executed into memory. When you call `render_react` from your view - rendering is done from preloaded components at speeds comparable to native Ruby partials.

## Installation
Just add render-react to your Gemfile and you're done.
```bash
echo 'gem render-react' >> Gemfile
bundle install
```

## Usage (Rails)
1. Include Render::React into your ApplicationHelper
```ruby
module ApplicationHelper
  include Render::React
  ...
```

2. Create initializer config/initializers/render_react.rb
```ruby
Render::React::Config.path File.join(Rails.root, 'app/assets/javascripts/components-local')
Render::React::Config.path File.join(Rails.root, 'some/other/directory')
```
or
```ruby
Render::React::Config.path(
  File.join(Rails.root, 'app/assets/javascripts/components-other'),
  File.join(Rails.root, 'some/other/directory')
)
```

3. Render react component into your view (e.g. slim):
```ruby
== render_react 'Card', \
  className: 'city-block swiper-slide', \
  href: city_path(city.slug), \
  text: city.location, \
  name: city.name, \
  cover: image_path(city.cover.square_thumb), \
  count: city.compilations.length
```

## Debugging
To be sure that everything is tip-top.

In terms of rendering time:
```ruby
- start = Time.now
== render_react 'ComponentName', \
  className: 'city-block swiper-slide', \
  ...
- finish = Time.now
- Rails.logger.warn "Render::React durability: #{Render::React::Compiler.instance_variable_get(:@durability)} time: #{finish - start}"
```

In terms of memory.
```bash
ps x -o rss,command  | grep "unicorn" | grep -v grep | sort
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rambler-digital-solutions/render-react. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
