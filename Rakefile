require 'find'

def number_from_file(filename)
  f = File.basename(filename)

  number, name = f.split("_", 2)
  return unless number =~ /^\d+$/

  number = number.to_i
  return if number >= 90
  [number, name]
end

EXTENSIONS_TO_DELETE = %w[
  .aux
  .fdb_latexmk
  .log
  .out
  .toc
  .bbl
  .blg
  .bcf
  .lof
  .tdo
  .synctex.gz
  .pyg
  .fls
  .lol
]

desc "Remove any superfluous files from LaTeX compilation"
task :cleanup do
  Find.find(File.dirname(__FILE__)) do |f|
    if File.file?(f)
      File.delete(f) if EXTENSIONS_TO_DELETE.detect{|ext| f.end_with? ext}
    end
  end
end

desc "Make room for new new section ID"
task :insert_section, :starting_from do |t, args|
  starting_from = args[:starting_from].to_i

  Find.find(File.join(File.dirname(__FILE__), 'sections')) do |f|
    next unless f.end_with?('.tex')

    number, name = number_from_file(f)
    next if !number || number < starting_from

    new_name = File.join(File.dirname(f), "#{(number + 1).to_s.rjust(2, "0")}_#{name}")
    if new_name != f
      puts "Renaming #{File.basename(f)} => #{File.basename(new_name)}"
      File.rename(f, new_name)
    end
  end
end

desc "Cleanup section numbering"
task :clean_sections do
  files = []
  Find.find(File.join(File.dirname(__FILE__), 'sections')) do |f|
    files << f if f =~ %r{/\d+_[^/]+.tex$}
  end

  i = 0
  files.sort.each do |f|
    number, name = number_from_file(f)
    next if !number || number <= (i += 1)

    new_name = File.join(File.dirname(f), "#{(i).to_s.rjust(2, "0")}_#{name}")
    if new_name != f
      puts "Renaming #{File.basename(f)} => #{File.basename(new_name)}"
      File.rename(f, new_name)
    end
  end
end

task :default => [:cleanup]