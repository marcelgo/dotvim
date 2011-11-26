# Rakefile
#
# Simple tasks for managing my .vim files


PLUGIN_LIST_TAG = '## Plugin List'
PLUGIN_LIST_NOTE = '_Note: Auto generated from `vundle.config`'
VIMRC_FILE = 'vimrc'
GVIMRC_FILE = 'gvimrc'
VUNDLE_CONFIG_FILE = 'vundle.config'
README_FILE = 'README.md'

namespace :vim do
  desc 'Create symlinks'
  task :link do
    begin
      File.symlink(".vim/#{VIMRC_FILE}", File.expand_path('~/.vimrc'))
      File.symlink(".vim/#{VIMRC_FILE}", File.expand_path('~/.gvimrc'))
    rescue NotImplementedError
      puts "File.symlink not supported, you must do it manually."
      if RUBY_PLATFORM.downcase =~ /(mingw|win)(32|64)/
        puts 'Windows 7 use mklink, e.g.'
        puts '  mklink _vimrc .vim\vimrc'
      end
    end

  end
end

namespace :plugins do

  desc 'Update the list of plugins in README.md'
  task :readme do
    plugins = parse_plugins_from_vimrc
    add_plugins_to_readme(plugins)
  end
end



# ----------------------------------------
# Helper Methods
# ----------------------------------------


# Just takes an array of strings that resolve to plugins from Vundle
def add_plugins_to_readme(plugins = [])
  lines = File.readlines(README_FILE).map{|l| l.chomp}
  index = lines.index(PLUGIN_LIST_TAG)
  unless index.nil?
    lines.insert(index+1, "\n#{PLUGIN_LIST_NOTE}\n\n")
    lines.insert(index+2, plugins.map{|p| " * [#{p[:name]}](#{p[:uri]})"})
    readme_file = File.open(README_FILE, 'w')
    readme_file << lines.join("\n")
    readme_file.close
  else
    puts "Error: Plugin List Tag (#{PLUGIN_LIST_TAG}) not found"
  end

end

# Returns an array of plugins denoted with Bundle
def parse_plugins_from_vimrc
  plugins = []
  File.new(VUNDLE_CONFIG_FILE).each do |line|
    if line =~ /^Bundle\s+["'](.+)["']/
      plugins << convert_to_link_hash($1)
    end
  end

  plugins
end

# Converts a Vundle link to a URI
def convert_to_link_hash(link)
  link_hash = {}

  if link =~ /([a-zA-Z0-9\-]*)\/([a-zA-Z0-9\-\._]*)/
    user = $1
    name = $2
    link_hash[:user] = user
    link_hash[:name] = name
    link_hash[:uri] = "https://github.com/#{user}/#{name}"
  else
    name = link
    link_hash[:name] = name
    link_hash[:uri] = "https://github.com/vim-scripts/#{name}"
  end

  link_hash
end
