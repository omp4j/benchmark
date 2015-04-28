load.dataset <- function(path.to.dataset, aggr=TRUE) {
	dataset <- read.csv(
		path.to.dataset,
		header = FALSE,
		sep = ";",
		col.names = c("id", "cores", "workload", "schedule", "speedup")
	)

	if (aggr) {
		aggregated <- setNames(
			aggregate(dataset[,c("speedup")], by=dataset[,c("id","cores","workload","schedule")], FUN=mean),
			c("id", "cores", "workload", "schedule", "speedup")
		)
		return(aggregated)
	} else {
		return(dataset)
	}
}

load.cpp.dataset <- function(path.to.dataset, path.to.serials, aggr=TRUE) {
	dataset <- read.csv(
		path.to.dataset,
		header = FALSE,
		sep = ";",
		col.names = c("id", "cores", "workload", "schedule", "t.start", "t.end")
	)
	dataset$time <- dataset$t.end - dataset$t.start

	serial <- read.table(
		path.to.serials,
		header = FALSE,
		sep = ";",
		col.names = c("t.start", "t.end")
	)
	serial$time <- serial$t.end - serial$t.start
	mserial <- mean(serial$time)

	dataset$speedup <- mserial / dataset$time

	dataset <- dataset[c("id", "cores", "workload", "schedule", "speedup")]

	if (aggr) {
		aggregated <- setNames(
			aggregate(dataset[,c("speedup")], by=dataset[,c("id","cores","workload","schedule")], FUN=mean),
			c("id", "cores", "workload", "schedule", "speedup")
		)
		return(aggregated)
	} else {
		return(dataset)
	}
}

load.normality.dataset <- function(path.to.dataset) {
	return(load.dataset(path.to.dataset)["speedup"][[1]])
}
