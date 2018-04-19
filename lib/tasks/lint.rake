###
#
# lint.rake - Run rubocop to check for style errors
#
require 'rubocop/rake_task'

desc 'Run rubocop ruby linter'
RuboCop::RakeTask.new(:lint) do |task|
  task.fail_on_error = false
  task.options = ['--display-cop-names']
end
