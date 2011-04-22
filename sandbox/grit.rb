require 'grit'

repo_dir = '/tmp/grit-sandbox.git'

FileUtils.rm_rf(repo_dir)
FileUtils.mkdir(repo_dir)
FileUtils.chdir(repo_dir)

system('git init')

repo = Grit::Repo.new(repo_dir)

file_name = 'test.txt'
file_content = "Hello World!\n"

# create a new file
File.open(file_name, 'w') { |f| f.write(file_content) }
repo.add(file_name)
repo.commit_index("Added #{file_name} file.")

# modify file
3.times do |n|
  file_content << "Line #{n}\n"
  File.open(file_name, 'w') { |f| f.write(file_content) }

  repo.add(file_name)
  repo.commit_index("Changed #{file_name} file ##{n}.")
end

# rename file
file_name = 'folder/test.txt'
FileUtils.mkdir('folder')
FileUtils.mv('test.txt', file_name)

repo.remove('test.txt')
repo.add(file_name)
repo.commit_index("Renamed #{file_name} file.")

# change renamed file content
file_content << "Yet another line\n"
File.open(file_name, 'w') { |f| f.write(file_content) }

repo.add(file_name)
repo.commit_index("Changed renamed file.")

commits = repo.log('master', file_name)
commits.each do |commit|
  p commit.message
  p commit.author.name
end

# diff
diff = repo.diff(commits.first, commits.last)
p diff

def line_class(line)
  if line =~ /^@@/
    'gc'
  elsif line =~ /^\+/
    'gi'
  elsif line =~ /^\-/
    'gd'
  else
    ''
  end
end

@left_diff_line_number = nil
def left_diff_line_number(id, line)
  if line =~ /^@@/
    m, li = *line.match(/\-(\d+)/)
    @left_diff_line_number = li.to_i
    @current_line_number = @left_diff_line_number
    ret = '...'
  elsif line[0] == ?-
    ret = @left_diff_line_number.to_s
    @left_diff_line_number += 1
    @current_line_number = @left_diff_line_number - 1
  elsif line[0] == ?+
    ret = ' '
  else
    ret = @left_diff_line_number.to_s
    @left_diff_line_number += 1
    @current_line_number = @left_diff_line_number - 1
  end
  ret
end

@right_diff_line_number = nil
def right_diff_line_number(id, line)
  if line =~ /^@@/
    m, ri = *line.match(/\+(\d+)/)
    @right_diff_line_number = ri.to_i
    @current_line_number = @right_diff_line_number
    ret = '...'
  elsif line[0] == ?-
    ret = ' '
  elsif line[0] == ?+
    ret = @right_diff_line_number.to_s
    @right_diff_line_number += 1
    @current_line_number = @right_diff_line_number - 1
  else
    ret = @right_diff_line_number.to_s
    @right_diff_line_number += 1
    @current_line_number = @right_diff_line_number - 1
  end
  ret
end

diff[0].diff.split("\n")[2..-1].each_with_index do |line, line_index|
  d = { :line  => line,
    :class => line_class(line),
    :ldln  => left_diff_line_number(0, line),
    :rdln  => right_diff_line_number(0, line) }
  p d
end
