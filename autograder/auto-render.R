# download all rmd files into the lecxx folder
# after render to pdf, review & score in canvas
# move pdf file to 'entered' folder


library(rmarkdown)

# define lecture number
lecnum <- "lec10"

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

