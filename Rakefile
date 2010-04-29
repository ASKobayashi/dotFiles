require 'rake'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  system "mkdir -p ~/.ssh" 
  Dir['*'].each do |file|
    next if %w[Rakefile README LICENSE].include? file
    
    # Handle authorized_keys special case
    dir = (%w[authorized_keys].include? file) ? "ssh/" : "" 

    if File.exist?(File.join(ENV['HOME'], ".#{dir+file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{dir+file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file, dir)
        when 'y'
          replace_file(file, dir)
        when 'q'
          exit
        else
          puts "skipping ~/.#{dir+file}"
        end
      end
    else
      link_file(file, dir)
    end
  end
end

def replace_file(file, dir="")
  system %Q{rm "$HOME/.#{dir+file}"}
  link_file(file)
end

def link_file(file, dir="")
  puts "linking ~/.#{dir+file}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/.#{dir+file}"}
end
