# Return subset of results, fixed on passed values
fix.workload.schedule <- function(dataset, name, workload, schedule="dynamic") {
	res <- dataset[
		dataset[, "workload"] == workload &
		dataset[, "schedule"] == schedule &
		dataset[, "id"] == paste("org.omp4j.benchmark.", name, sep = "")
	,][c("cores", "speedup")]

	return(res)
}

# Return subset of results, fixed on passed values
fix.cores.schedule <- function(dataset, name, cores, schedule="dynamic") {
	res <- dataset[
		dataset[, "cores"] == cores &
		dataset[, "schedule"] == schedule &
		dataset[, "id"] == paste("org.omp4j.benchmark.", name, sep = "")
	,][c("workload", "speedup")]

	return(res)
}
