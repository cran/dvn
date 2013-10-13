dvQuery <- function(verb, query = NULL, dv = getOption('dvn'), browser=FALSE, ...){
	# Data Sharing API workhorse query function
	if(!verb %in% c("metadataSearchFields", "metadataSearch", "metadataFormatsAvailable", "metadata", "downloadInfo", "download"))
		stop("API query verb not recognized")
	if(is.null(dv) || dv=="")
		stop("Must specify Dataverse URL as 'dv'")
	else{
		https <- substring(dv,1,5)
		if(!https=="https")
			stop("API query must use https")
		slash <- substring(dv,nchar(dv),nchar(dv))
		if(!slash=="/")
			dv <- paste(dv,"/",sep="")
	}
	url <- paste(dv,"api/",verb,sep="")
	if(!is.null(query))
		url <- paste(url,query,sep="/")
	if(browser)
		browseURL(url)
	else{
		xml <- getURL(url, followlocation = TRUE, 
					#ssl.verifypeer = TRUE, ssl.verifyhost = TRUE,
					ssl.verifypeer = FALSE, ssl.verifyhost = FALSE, ...)
					#cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
	    if('html' %in% names(xmlChildren(xmlParse(xml)))){
            temp <- htmlTreeParse(xml,useInternalNodes=TRUE)
            out <- 
            c(xpathApply(temp,'//title/text()',xmlValue)[[1]],
              xpathApply(temp,'//h1/text()',xmlValue)[[1]],
              unlist(xpathApply(temp,'//p/text()',xmlValue)))
            message('Operation failed with the following response:\n',paste(out,'\n',collapse='\n'))
            return(NULL)
        }
        else
            return(xml)
	}
}
