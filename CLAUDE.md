# CLAUDE.md

## Testing

This project uses **RSpec**, not Minitest.

- Run the full test suite: `bundle exec rspec`
- Run a specific file: `bundle exec rspec spec/models/item_spec.rb`
- Run a specific test by line: `bundle exec rspec spec/models/item_spec.rb:10`
- Default Rake task also runs specs: `bundle exec rake`
