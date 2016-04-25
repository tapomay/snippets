#!/usr/bin/ruby

def log_info(msg)
    $stdout.puts("[#{Time.now.to_s}] INFO: #{msg}")
end

def log_debug(msg)
    $stdout.puts("[#{Time.now.to_s}] DEBUG: #{msg}")
end

def log_warn(msg)
    $stdout.puts("[#{Time.now.to_s}] WARNING: #{msg}")
end

def log_error(msg)
    $stderr.puts("[#{Time.now.to_s}] ERROR: #{msg}")
end

if !ARGV[0].nil?
    filepath=ARGV[0]
    TMPDIR="/tmp"
    suffix=`date +%s`
    i = filepath.rindex("/")
    filename=filepath[(i+1)..-1]
    filename = filename.delete("")
    lastindex = [5,filename.length].min
    partial=filename[0..lastindex]

    dir= TMPDIR + '/' + partial + "-" + suffix
    DIRNAME = dir.strip
    # CWD=`pwd`
    # puts "CWD= " + CWD
    puts "TARGETDIR= " + DIRNAME
    Dir.mkdir("#{DIRNAME}")
    Dir.chdir("#{DIRNAME}")
    cdr = `pwd`
    log_info "CWD to #{cdr}"

    if !ARGV[1].nil?
        startPage = ARGV[1]
    else
        startPage = 1
    end

    if !ARGV[2].nil?
        pages = ARGV[2]
    else
        pages = 2
    end

    log_info("Processing pages #{startPage}-#{pages} of #{filepath} into dir #{DIRNAME}")
    outfile = "#{filename}.out.pdf"
    `convert xc:none -page Letter #{outfile}`
    (1..pages.to_i).each do |n|
        pgindex = startPage.to_i + n
        pgFileName = "#{filename}-pg-#{pgindex}"
        puts pgFileName

        `pdftk #{filepath} cat #{pgindex} output #{pgFileName}-orig.pdf`
        log_info "Extracted page: #{pgFileName}-orig.pdf"

        puts "pdftoppm #{pgFileName}-orig.pdf -f 1 -l 1 -r 600 #{pgFileName}"
        `pdftoppm #{pgFileName}-orig.pdf -f 1 -l 1 -r 600 #{pgFileName}`
        ppmfile=`ls *.ppm`
        ppmfile=ppmfile.strip
        log_info "Generated PPM: #{ppmfile}"
        # `rm #{pgFileName}-orig.pdf`

        puts "convert #{ppmfile} #{pgFileName}.tif"
        `convert #{ppmfile} #{pgFileName}.tif`
        `rm #{ppmfile}`

        puts "tesseract #{pgFileName}.tif #{pgFileName} -l eng"
        `tesseract #{pgFileName}.tif #{pgFileName} -l eng`
        # log_info "Tesseract complete: #{pgFileName}.txt"
        `rm #{pgFileName}.tif`

        puts "enscript -f Arial12 -p #{pgFileName}.ps #{pgFileName}.txt"
        `enscript -f Arial12 -p #{pgFileName}.ps #{pgFileName}.txt`
        `rm #{pgFileName}.txt`

        puts "ps2pdf #{pgFileName}.ps #{pgFileName}.pdf"
        `ps2pdf #{pgFileName}.ps #{pgFileName}.pdf`
        `rm #{pgFileName}.ps`

        puts "pdftk #{outfile} #{pgFileName}.pdf output #{outfile}.tmp"
        `pdftk #{outfile} #{pgFileName}.pdf #{pgFileName}-orig.pdf output #{outfile}.tmp`
        `mv #{outfile}.tmp #{outfile}`
        # `rm #{pgFileName}.pdf`
        # `cat #{pgFileName} >> #{pgFileName}.txt; echo "[pagebreak]" >> pdf-ocr-output.txt; done
        # `rm #{pgFileName}`
        log_info "Completed pageno. #{pgindex}"
    end

    # Dir.chdir("#{CWD}")
    log_info("Deleting #{DIRNAME}")
    # `rm -fr #{DIRNAME}`
else
    log_error("Invalid input (pass filename from commandline)")
end

