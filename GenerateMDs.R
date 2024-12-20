## Make links, then generate MD's
# Part 1: generate links:
allFiles <- list.files(path = "~/GitHubStuff/jasp-gif-library//")

myFileLinks <- list()
for (thisFile in allFiles) {
  
  
  subFiles <- list.files(path = paste0("~/GitHubStuff/jasp-gif-library/", thisFile))
  
  if (paste0(thisFile, ".jasp") %in% subFiles) {
    
    noSpaceFileName <- gsub(x = thisFile, pattern =" ", replacement = "%20")
    underscoreFileName <- gsub(x = thisFile, pattern =" ", replacement = "_")
    
    jaspLink <- "[.jasp](https://johnnydoorn.github.io/jasp-gif-library/FILENAMEHERE/FILENAMEHERE.jasp)"
    
     
    myFileLinks[[thisFile]] <- list(jaspLink = gsub(x = jaspLink, pattern = "FILENAMEHERE", replacement = noSpaceFileName))
    
  }
}


analysisNames <- list.files("~/GitHubStuff/jasp-gif-library/")
# Extract numbers from the beginning of each string
numbers <- as.numeric(gsub("^([0-9]+).*", "\\1", analysisNames))
# Sort the vector based on the extracted numbers
analysisNames <- analysisNames[order(numbers)]
analysisList <- list()
for (thisAnalysis in analysisNames) {
  
  subFiles <- list.files(path = paste0("~/GitHubStuff/jasp-gif-library/gifs/", thisAnalysis))
  
  thisAnalysisData <- subFiles[grepl(x = subFiles, pattern = ".jasp")]
  thisAnalysisData <- gsub(x = thisAnalysisData, pattern = ".jasp", replacement = "")
  
  analysisList[[thisAnalysis]] <- list()
  
  for (thisData in thisAnalysisData) {
    
    analysisList[[thisAnalysis]][[thisData]] <- myFileLinks[[thisData]]
    
  }
}



# Part 2: generate md files for each chapter
# Used for matching the book links:
unlistedAnalysisList <- unlist(analysisList, recursive = F)
unlistedDataNamesList <- unlist(lapply(analysisList, names))

for (i in seq_along(analysisList)) {
  chapterList <- analysisList[[i]]
  chapterTitle <- names(analysisList)[i]
  file_name <- paste0("myChapters/chapter_", i, ".md")
  # Remove numbers before a period using regular expressions
  chapterTitle <- gsub("\\d+\\.", "", chapterTitle)
  
  cat(paste("#", chapterTitle, "\n\n"), file = file_name)
  
  
  allDataNames <- names(chapterList)
  
  
  for (thisDataName in allDataNames) {
    cat(paste("\n\n##", thisDataName, "\n"), file = file_name, append = TRUE)
    # chapter_content <- chapterList[[thisDataName]][[1]]
    # cat(chapter_content, file = file_name, append = TRUE)
    item_list <- chapterList[[thisDataName]]
    
    cat("|  |  |  |\n", file = file_name, append = TRUE)
    cat("|---|---|---|\n", file = file_name, append = TRUE)
    
    # for (item in item_list) {
    # bullet_point <- paste0(" ", paste(item, collapse = " "))
    # bullet_list <- paste(bullet_list, paste("|", item, "|"), sep = " ")
    result <- paste("|", paste(item_list, collapse = " | "), "|", sep = "")
    
    cat(result, file = file_name, append = TRUE)
    
  }
  
  if (chapterTitle == "Books") {
    
    for (thisBook in bookTitles) {
      
      cat(paste("\n\n##", thisBook, "\n"), file = file_name, append = TRUE)
      
      allDataNames <- bookDatasets[[thisBook]]
      
      matchedBookDataList <- unlistedAnalysisList[match(allDataNames, unlistedDataNamesList)]
      
      for (thisDataName in names(matchedBookDataList)) {
        
        cat(paste("\n\n###", sub(".*\\.", "", thisDataName), "\n"), file = file_name, append = TRUE)
        # chapter_content <- chapterList[[thisDataName]][[1]]
        # cat(chapter_content, file = file_name, append = TRUE)
        cat("|  |  |  |\n", file = file_name, append = TRUE)
        cat("|---|---|---|\n", file = file_name, append = TRUE)
        
        item_list <- matchedBookDataList[[thisDataName]]
        
        result <- paste("|", paste(item_list, collapse = " | "), "|", sep = "")
        
        cat(result, file = file_name, append = TRUE)
        
      }
    }
  }
  
}
