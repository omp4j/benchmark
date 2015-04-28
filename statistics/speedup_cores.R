# Plot speedup/core graph
plot.speedup.core <- function(dataset, name, iters=10000, schedule="dynamic", max.cores=50, plot.optimal=TRUE, plot.regression=TRUE) {

	# plot dataset
	plot(
		dataset[,c("cores", "speedup")],
		main = paste(name, " benchmark\n", iters, "workload, ", schedule, " scheduling", sep = ""),
		xlab = "cores",
		ylab = "speedup",
		xlim = c(0, max.cores),
		ylim = c(0, max.cores)
	)

	# plot optimal speedup
	if (plot.optimal) {
		abline(a = 0, b = 1, col = "blue")
	}

	# plot regression
	if (plot.regression) {
		regression <- lm(formula = dataset[, "speedup"] ~ dataset[, "cores"] + I(dataset[, "cores"]^2))
		kk <- coefficients(regression)
		coefs <- c(kk[[1]], kk[[2]], kk[[3]])
		curve(coefs[1] + coefs[2]*x + coefs[3]*x^2, add=TRUE)
	}
}

# Return loaded *.csv file with computed wall-time [ms]
load.dataset <- function(path.to.dataset) {
	dataset <- read.csv(
		path.to.dataset,
		header = FALSE,
		sep = ";",
		col.names = c("id", "name", "cores", "iters", "schedule", "time.start", "time.end")
	)
	dataset["time.wall"] <- (dataset["time.end"] - dataset["time.start"]) / 1000 / 10000
	return(dataset)
}

# Return subset of results, fixed on passed values
fix.dataset.with.iters.schedule <- function(dataset, name, iters=10000, schedule="dynamic") {
	res.pre <- dataset[
		dataset[, "iters"] == iters &
		dataset[, "schedule"] == schedule &
		dataset[, "name"] == paste("org.omp4j.benchmark.pre.", name, sep = "")
	,][c("cores", "time.wall")]

	res.post <- dataset[
		dataset[, "iters"] == iters &
		dataset[, "schedule"] == schedule &
		dataset[, "name"] == paste("org.omp4j.benchmark.post.", name, sep = "")
	,][c("cores", "time.wall")]

	res <- merge(
		res.pre,
		res.post,
		by = "cores",
		suffixes = c(".pre", ".post")
	)

	res["speedup"] <- res["time.wall.pre"] / res["time.wall.post"]
	return(res)
}

# Usage:
dataset <- load.dataset("./Dropbox/omp4j/benchmark/statistics/fib.csv")
iter.10k.schedule.dynamic <- fix.dataset.with.iters.schedule(dataset, "Fibonacci", iters = 10000, schedule = "dynamic")
plot.speedup.core(iter.10k.schedule.dynamic, "Fibonacci", iters = 10000, schedule = "dynamic")

iter.10k.schedule.static <- fix.dataset.with.iters.schedule(dataset, "Fibonacci", iters = 10000, schedule = "static")
plot.speedup.core(iter.10k.schedule.static, "Fibonacci", iters = 10000, schedule = "static")

iter.1k.schedule.dynamic <- fix.dataset.with.iters.schedule(dataset, "Fibonacci", iters = 1000, schedule = "dynamic")
plot.speedup.core(iter.1k.schedule.dynamic, "Fibonacci", iters = 1000, schedule = "dynamic")

iter.1k.schedule.static <- fix.dataset.with.iters.schedule(dataset, "Fibonacci", iters = 1000, schedule = "static")
plot.speedup.core(iter.1k.schedule.static, "Fibonacci", iters = 1000, schedule = "static")

# c++ comparison
plot.speedup.core(iter.10k.schedule.dynamic, "Fibonacci omp4j vs. C++", iters = 10000, schedule = "dynamic")
par(new=T)
plot(cpp.fixed[,c("cores", "speedup")], col="red", axes = F, xlim=c(0,50), ylim=c(0,50))



