
#' @title delete_points
#' @param raw_data data
#' @description Delete groups from scatterplots
 
delete_group <- function(raw_data){
	ids <- unique(raw_data$id)
	remove <- menu(ids)
	raw_data <- subset(raw_data, id != ids[remove])
	raw_data$id <- droplevels(raw_data$id)
	return(raw_data)
}


#' @title edit_group
#' @param raw_data data
#' @param group_id group_id
#' @param calpoints The calibration points
#' @param ... other functions to pass to internal_redraw
#' @description Edit group points in scatterplots
 
edit_group <- function(raw_data, group_id, calpoints, ...){
	
	cols <- rep(c("red", "green", "purple"),length.out=90)
	pchs <- rep(rep(c(19, 17, 15),each=3),length.out=90)

	box_y <- c(mean(calpoints$y[3:4]), mean(calpoints$y[3:4]),0,0,mean(calpoints$y[3:4]))/2
	box_x <- c(0,mean(calpoints$x[1:2]), mean(calpoints$x[1:2]),0,0)/2


	if(!is.null(group_id)) {
		group_data <- data.frame()
		i <- if(nrow(raw_data)==0){ 1 }else{ max(raw_data$group) + 1 }
		add_removeQ <- "a"
	}else{
		group_id <- unique(raw_data$id)[ menu(unique(raw_data$id)) ]
		group_data <- subset(raw_data, id==group_id)
		i <- unique(group_data$group)
		add_removeQ <- "b"
		raw_data <- subset(raw_data, id != group_id)
		
		idQ <- user_options("Change group identifier? (y/n) ",c("y","n"))
		if(idQ=="y"){
			group_id <- user_unique("\nGroup identifier: ", unique(raw_data$id))
			group_data$id <- group_id
		}
	}
	

	while(add_removeQ!="c"){

		if(add_removeQ=="a"){
			polygon(box_x,box_y, col="red", border=NA,xpd=TRUE)
			cat("\nClick on points you want to add.\nIf you want to remove a point, or are finished with a group, \nexit by clicking on red box in bottom left corner, then follow prompts\n")
		} 
		while(add_removeQ=="a"){
			select_points <- locator(1,type="p", lwd=2, col=cols[i], pch=pchs[i])			
			if( select_points$x<max(box_x) & select_points$y<max(box_y) & select_points$x>min(box_x) & select_points$y>min(box_y)) {
				add_removeQ <- "b"
			}
			else{ 
				group_data <- rbind(group_data, data.frame(id=group_id, x=select_points$x, y=select_points$y, group=i, col=cols[i], pch=pchs[i]) )
			}
		}

		if(add_removeQ=="d"){
			cat("\nClick on point you want to delete\n")
			remove <- identify(group_data$x,group_data$y, n=1)
			if(length(remove)>0) {
				points(group_data$x[remove], group_data$y[remove],cex=2, col="white", pch=19)
				group_data <- group_data[-remove,]
			}
		}

		internal_redraw(...,calpoints=calpoints,raw_data=rbind(raw_data, group_data), calibration=TRUE, points=TRUE)
		add_removeQ <- readline("\nAdd or Delete points to this group, or Continue? (a/d/c) \n")
	}

	raw_data <- rbind(raw_data, group_data)		
	return(raw_data)	
}


#' @title group_scatter_extract
#' @param edit logical; whether in edit mode 
#' @param raw_data raw data
#' @param ... arguments passed to internal_redraw
#' @description Extraction of data from scatterplots

group_scatter_extract <- function(edit=FALSE, raw_data = data.frame(), ...){

	editQ <- if(edit){ "b" }else{ "a" }
	if(!edit) cat("\nIf there are multiple groups, enter unique group identifiers (otherwise press enter)")

	while(editQ != "f"){
	
		group_id <- NULL

		if(editQ=="a"){
			group_id <- user_unique("\nGroup identifier: ", unique(raw_data$id))
			editQ <- "e"
		}

		if(editQ == "e") raw_data <- edit_group(raw_data, group_id, ...)

		if(editQ == "d") raw_data <- delete_group(raw_data)
	
		internal_redraw(...,raw_data=raw_data, calibration=TRUE, points=TRUE)
		editQ <- readline("\nAdd group, Edit group, Delete group, or Finish plot? (a/e/d/f) \n")
	}
	return(raw_data)
}





