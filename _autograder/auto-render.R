# download all rmd files into the lecxx folder
# after render to pdf, review & score in canvas
# move pdf file to 'entered' folder


library(rmarkdown)
library(pdftools)

# ---- NEW: helper to detect YAML parse error in PDFs ----
check_yaml_error <- function(pdf_path) {
  txt <- paste(pdf_text(pdf_path), collapse = "\n")
  
  if (grepl("Error in parse\\(text = input\\)", txt)) {
    return("fix YAML")
  } else {
    return("ok")
  }
}

# ---- NEW: read student name from the PDF filename ----
student_from_filename <- function(pdf_path) {
  nm <- tools::file_path_sans_ext(basename(pdf_path))  # drop folders + .pdf
  nm <- gsub("_", " ", nm)                             # underscores -> spaces
  nm <- trimws(nm)                                     # clean ends
  nm
}

# ---- NEW: check author section contains student name (and not the placeholder) ----
author_section_ok <- function(pdf_path, student_name, n_pages = 2) {
  pages <- pdf_text(pdf_path)
  top <- paste(pages[seq_len(min(n_pages, length(pages)))], collapse = "\n")
  
  if (grepl("Put your name here", top, fixed = TRUE)) {
    return(FALSE)
  }
  
  grepl(tolower(student_name), tolower(top), fixed = TRUE)
}

# ---- NEW: standard output row ----
make_result_row <- function(student, score = NA_real_, message = "ok") {
  data.frame(
    student = student,
    score = score,
    message = message,
    stringsAsFactors = FALSE
  )
}

# ---- NEW: grade a single PDF (score placeholder for now) ----
grade_one_pdf <- function(pdf_path) {
  student <- student_from_filename(pdf_path)
  
  # Rule: YAML parse error anywhere => fix YAML
  if (check_yaml_error(pdf_path) == "fix YAML") {
    return(make_result_row(student, score = NA_real_, message = "fix YAML"))
  }
  
  # Rule: Author section must contain student name and not placeholder
  if (!author_section_ok(pdf_path, student_name = student)) {
    return(make_result_row(student, score = NA_real_, message = "author/name not updated"))
  }
  
  # Score will be filled in next sub-issue (key-based % complete)
  return(make_result_row(student, score = NA_real_, message = "ok"))
}

# ---- NEW: grade all PDFs in entered folder ----
grade_entered_pdfs <- function(lecnum) {
  entered_dir <- paste0(lecnum, "/entered/")
  if (!dir.exists(entered_dir)) {
    return(data.frame(student=character(), score=numeric(), message=character()))
  }
  
  pdfs <- list.files(entered_dir, pattern="\\.pdf$", full.names = TRUE)
  if (length(pdfs) == 0) {
    return(data.frame(student=character(), score=numeric(), message=character()))
  }
  
  results <- do.call(rbind, lapply(pdfs, grade_one_pdf))
  results
}


# define lecture number
lecnum <- "lec10"

# ---- NEW: delete PDFs in lec folder that already exist in entered/ ----
entered_dir <- paste0(lecnum, "/entered/")

if (dir.exists(entered_dir)) {
  pdf_main <- list.files(paste0(lecnum, "/"), pattern="\\.pdf$", full.names = TRUE)
  pdf_ent  <- list.files(entered_dir, pattern="\\.pdf$", full.names = TRUE)
  
  if (length(pdf_main) > 0 && length(pdf_ent) > 0) {
    main_names <- basename(pdf_main)
    ent_names  <- basename(pdf_ent)
    
    dupes <- pdf_main[main_names %in% ent_names]
    
    if (length(dupes) > 0) {
      file.remove(dupes)
      message("Deleted duplicate PDFs: ", paste(basename(dupes), collapse = ", "))
    }
  }
}



# get all files to be rendered
all.files <- list.files(paste0(lecnum, "/"), pattern=".Rmd|.rmd")

# get list of files already entered
ename <- list.files(paste0(lecnum, "/entered/"), pattern=".pdf")

# anti-join to only keep files needing to be rendered
a <- gsub(".Rmd", "", all.files)
b <- gsub(".pdf", "", ename)
filename <- all.files[!a %in% b]
drop <- all.files[a %in% b]

# remove RMD files that have already been rendered
if(length(drop)>0){
  for(d in 1:length(drop)){
    file.remove(paste0(lecnum, "/", drop[d]))
  }
}

# define vector of in and out paths for each file
inpath <- paste0(lecnum, "/", filename)
outfile <- gsub(".Rmd", "", filename)
entered <- paste0(lecnum, "/entered/", filename)


for(f in 1:length(filename)){
#for(f in 1:2){
  err <- FALSE # initialize
  
  # try to render, even if there is an error. 
  tryCatch({
    render(inpath[f], output_format = "pdf_document", 
           output_file = outfile[f], envir = new.env())  
  }, 
  error = function(e){err <<- TRUE})
  
  if(err){next} # if there is an error go to the next file
  if(!err){ # if no error delete the RMD file
    file.remove(inpath[f])  
  }
}

