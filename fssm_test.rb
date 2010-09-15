require 'fssm'

path = ARGV[0]
FSSM.monitor(path, '**/*') do
  update do |base, relative|
    p 'file updated'
    p "base: #{base}"
    p "relative: #{relative}"
  end

  delete {|base, relative|}
  create {|base, relative|}
end
