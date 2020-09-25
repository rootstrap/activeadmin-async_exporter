ActiveAdmin.register User do
  permit_params :username

  csv_async do
    csv_column(:username) # Simple attribute example
    csv_column(:single) { |x| "This is an example block on the same line: #{x.username}" }
    csv_column(:multi) do |x|
      this_is = 'This is'
      a_block = 'a block'
      multiline_example = 'multiline example:'
      username = x.username

      [this_is, a_block, multiline_example, username].join(' ')
    end
  end
end
