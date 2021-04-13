# Filename: Concat_files.R
# 
# Author: Luke Miller  May 21, 2019
###############################################################################

#' Concatenate multiple daily gape files into one data frame
#' 
#' @param filenames A vector of filenames (including path) to be concatenated
#' @return A data frame consisting of the input files concatenated and sorted 
#' chronologically. 

ConcatGapeFiles <- function(filenames, myTimeZone = 'UTC',verbose=TRUE){
	if(verbose){
		pb = txtProgressBar(min=0,max = length(filenames), style = 3)
	}
# Open the raw data files and concatenate them.
	for (f in 1:length(filenames)){
		if(verbose) setTxtProgressBar(pb,f)
		
		dattemp = read.csv(filenames[f])
		###########################
	# Columns:
	# POSIXt: elapsed seconds since 1970-01-01 00:00:00 (unix epoch) in whatever
	#         timezone the sensor was set to during deployment. Presumably UTC
	# DateTime: human-readable character date and time, in whatever timezone the
	#         sensor was set to during deployment 
	# Hallx: Raw analog to digital converter value for the indicated Hall effect 
	#		channel. There are 16 channels (numbered 0-15) on the GapeTracker
	# Battery.V:  Supply battery voltage
		#########################
	# Convert the DateTime column to a POSIXct object.
		dattemp$DateTime = as.POSIXct(dattemp$DateTime, tz=myTimeZone) 	

		
		# Concatenate the data files. 
		if (f == 1){
			dat = dattemp
		} else if (f > 1){
			dat = rbind(dat,dattemp)
		}
	}
	if(verbose) close(pb)
# Reorder the concatenated data frame by the DateTime values in case the files
# were not fed in in chronological order
	dat = dat[order(dat$DateTime),]
}





